#Include <DBA>
#Include src/Models.ahk

class DbaSuite
{

    class ActiveRecord
    {

        class Constructor
        {

            WithValidPrimaryKey_ShouldReturnRecordWithAttributes()
            {
                local porder := new Models.DBA.porder("PO114")
                YUnit.assert(porder.exists, "porder did not exist when it should have")
                YUnit.assert(porder.status = "Closed", "porder.status equaled '" porder.status "'")
            }

            WithoutValidPrimaryKey_ShouldReturnEmptyRecord()
            {
                local porder := new Models.DBA.porder("")
                YUnit.assert(!porder.exists, "porder existed when it should not have")
            }

        }

        class Build
        {

        }

    }

    class RecordSet {

        class Build {

            NoCriteria_ReturnsArrayWithRecords()
            {
                local records := DBA.RecordSet.build("porder")
                YUnit.assert(records.Count() != 0, "records.Count() is " records.Count())
            }

            SimpleWhereCriteria_ReturnsArrayWithRecords()
            {
                local records := DBA.RecordSet.build("porder", "ponum = 'PO114' AND status = 'Closed'")
                YUnit.assert(records.Count() != 0, "records.Count() is " records.Count())
            }

            OrderByCriteria_ReturnsArrayWithRecordsInOrder()
            {
                local records := DBA.RecordSet.build("porder", "", "ponum DESC")
                YUnit.assert(records[1].ponum == "PO9999", "First record should have ponum 'PO9999', found '" records[0].ponum "'")
            }

            LimitCriteria_ReturnsOnlyXRecords()
            {
                local records := DBA.RecordSet.build("porder", "", "", 10)
                outputStr := ""
                for index, record in records {
                    outputStr .= record.ponum "`n"
                }
                YUnit.assert(records.Count() == 10, "records.Count() should be 10, but instead is '" records.Count() "': " outputStr)
            }

            LimitCriteriaAndPageCriteria_ReturnsOnlyXRecords()
            {
                local records := DBA.RecordSet.build("porder", "", "", 10, 2)
                outputStr := ""
                for index, record in records {
                    outputStr .= record.ponum "`n"
                }
                YUnit.assert(records.Count() == 10, "records.Count() should be 10, but instead is '" records.Count() "': " outputStr)
            }

            LimitCriteriaAndPageCriteria_ReturnsOnlyCorrectRecords()
            {
                local records := DBA.RecordSet.build("porder", "", "ponum DESC", 10, 2)
                YUnit.assert(records[1].ponum == "PO9989", "records[1].ponum should be 'PO9989', found '" records[1].ponum "'")
            }
        }

    }

}