; Models.Receiver
class Receiver
{
    poNumber := ""
    partNumber := ""
    lineReceived := ""
    partDescription := ""
    lineQuantity := ""
    supplier := ""
    lotNumbers := []
    quantities := []
    locations := []
    hasCert := []

    currentLotInfo[key := ""] {
        get {
            lotInfo := {}
            index := this.lotNumbers.MaxIndex()
            lotInfo["number"] := this.lotNumbers[index]
            lotInfo["quantity"] := this.quantities[index]
            lotInfo["location"] := this.locations[index]
            lotInfo["hasCert"] := this.hasCert[index]
            if (key == "" || !lotInfo.HasKey(key))
                return lotInfo
            return lotInfo[key]
        }
    }

    __New()
    {
    }

    PullAdditionalInfo()
    {
        DB := new DBConnection()
        query := "SELECT p.qty, i.supplier, i.descript FROM podetl p LEFT JOIN item i ON p.reference = i.itemcode WHERE p.line='" this.lineReceived "' AND p.ponum='" this.poNumber "' AND p.reference='" this.partNumber "';"
        res := DB.query(query)
        if (res.empty()) {
            throw Exception("Could not pull in additional receiving details from PO")
        }
        this.supplier := res.row(1)["supplier"]
        this.lineQuantity := res.row(1)["qty"]
        this.partDescription := res.row(1)["descript"]
    }

}