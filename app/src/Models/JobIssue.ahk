; === Script Information =======================================================
; Name .........: Job Issue Model
; Description ..: Contains all the data required to perform a job issue
; AHK Version ..: 1.1.36.02 (Unicode 64-bit)
; Start Date ...: 04/14/2024
; OS Version ...: Windows 11
; Language .....: English - United States (en-US)
; Author .......: Austin Fishbaugh <austin.fishbaugh@gmail.com>
; Filename .....: JobIssue.ahk
; ==============================================================================

; === Revision History =========================================================
; Revision 1 (04/14/2024)
; * Added This Banner
;
; === TO-DOs ===================================================================
; ==============================================================================
; ! DO NOT INCLUDE DEPENDENCIES HERE, DO SO IN TOP-LEVEL PARENT
; Models.JobIssue
class JobIssue 
{
    data := {}
    needsLotNumber := false

    lineIndex[]
    {
        get {
            return this.data.lineNo / 10
        }
    }

    jobNumber[]
    {
        get {
            return this.data.jobNumber
        }
        set {
            jobNumber := value ""

            results := DBA.QueryBuilder
                .from("jobs")
                .select("jobstats")
                .where({"jobno=": jobNumber})
                .limit(1)
                .run()

            if (results.count() < 1) {
                throw new @.ValidationException(A_ThisFunc, "The Job # you entered does not exist in the database.", {jobNumber: jobNumber})
            }

            jobStatus := results.row(1)["jobstats"]
            
            if (jobStatus != "RELEASED") {
                throw new @.ValidationException(A_ThisFunc, "The Job # you entered does not have status RELEASE, and cannot be issued to.", {jobNumber: jobNumber, jobStatus: jobStatus})
            }

            return this.data.jobNumber := jobNumber ""
        }
    }

    partNumber[]
    {
        get {
            return this.data.partNumber
        }

        set {
            ; implement
            partNumber := value ""

            results := DBA.QueryBuilder
                        .from("jobdetl")
                        .select("jobdetl.refid as refid, jobdetl.sortno as sortno, bomdel.fixorvar as fixorvar")
                        .join("bomdel", "jobdetl.bomdno = bomdel.bomdno")
                        .where({"refid=": partNumber, "jobno=": this.data.jobNumber}) 
                        .run()
            
            if (results.data().count() < 1 || results.row(1)["refid"] != partNumber) {
                throw new @.ValidationException(A_ThisFunc, "The Part # provided could not be found on the Job #.", {partNumber: partNumber, jobNumber: this.data.jobNumber})
            }

            if (results.data().count() == 1) {
                this.data.lineNo := Format("{1:u}", results.row(1)["sortno"])
            } else {
                for rowNumber, row in results.data() {
                    if (row["fixorvar"] == "V" && row["sortno"] ) {
                        this.data.lineNo := row["sortno"]
                        break
                    }
                }
                if (!(this.data.lineNo > 0)) {
                    for rowNumber, row in results.data() {
                        if (row["sortno"] > 0) {
                            this.data.lineNo := row["sortno"]
                            break
                        }
                    }
                }
                if (!(this.data.lineNo > 0)) {
                    throw new @.NotFoundException(A_ThisFunc, "Could not find a row with a non-zero line number.", {partNumber: partNumber, jobNumber: this.data.jobNumber})
                }
            }

            results := DBA.QueryBuilder
                        .from("item_char_def_hist")
                        .select("start_dt, end_dt")
                        .where({"itemcode=": partNumber, "start_dt": "IS NOT NULL", "end_dt": "IS NULL"})
                        .limit(1)
                        .run()

            if (results.count() == 1) {
                this.needsLotNumber := true
            }

            return this.data.partNumber := partNumber ""
        }
    }

    lotNumber[]
    {
        get {
            return this.data.lotNumber
        }
        
        set {
            ; implement
            lotNumber := value ""

            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("lotno")
                        .groupBy("itemcode, itemloc, lotno")
                        .having({"itemcode=": this.data.partNumber, "lotno=": lotNumber, "SUM(qty)>": 0})
                        .limit(1)
                        .run()
            
            if (results.count() != 1 || results.row(1)["lotno"] != lotNumber) {
                throw new @.ValidationException(A_ThisFunc, "The Lot # provided isn't attached to the Part # provided.", {lotNumber: lotNumber, partNumber: this.data.partNumber})
            }

            return this.data.lotNumber := lotNumber ""
        }
    }

    location[]
    {
        get {
            return this.data.location
        }
        
        set {
            location := value ""

            results := DBA.QueryBuilder
                        .from("locations")
                        .select("locid")
                        .where({"locid=": location})
                        .limit(1)
                        .run()
            
            if (results.count() != 1 || results.row(1)["locid"] != location) {
                throw new @.ValidationException(A_ThisFunc, "The location entered is invalid.", {location: location})
            }

            having := {}
            having["itemcode="] := this.data.partNumber
            having["SUM(qty)>"] := 0
            having["itemloc="] := location
            if (this.needsLotNumber) {
                having["lotno="] := this.data.lotNumber
            }

            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("itemloc")
                        .groupBy("itemcode, itemloc, lotno")
                        .having(having)
                        .limit(1)
                        .run()
            
            if (results.count() != 1 || results.row(1)["itemloc"] != location) {
                throw new @.ValidationException(A_ThisFunc, "The Part/Lot # combination is not found at the provided location (within the database).", {partNumber: this.data.partNumber, lotNumber: this.data.lotNumber, location: location})
            }

            return this.data.location := location ""
        }
    }

    quantity[]
    {
        get {
            return this.data.quantity
        }

        set {
            quantity := value

            having := {}
            having["itemcode="] := this.data.partNumber
            having["SUM(qty)>="] := quantity 
            having["itemloc="] := this.data.location
            if (this.needsLotNumber) {
                having["lotno="] := this.data.lotNumber
            }

            results := DBA.QueryBuilder
                        .from("itemh")
                        .select("SUM(qty) as qty")
                        .groupBy("itemcode, itemloc, lotno")
                        .having(having)
                        .limit(1)
                        .run()

            databaseQuantity := Trim(results.row(1)["qty"]) * 1.0
            quantity := Trim(quantity) * 1.0

            if (results.count() != 1 || databaseQuantity < quantity) {
                throw new @.ValidationException(A_ThisFunc, "The quantity you are trying to issue is more than what exists at the location for the given part/lot # combination.", {partNumber: this.data.partNumber, lotNumber: this.data.lotNumber, location: this.data.location, quantity: quantity})
            }

            ; TODO: Check if quantity remaining on job is greater than quantity issued

            return this.data.quantity := quantity
        }
    }
}