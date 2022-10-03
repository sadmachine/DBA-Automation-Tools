class InspectionReport extends Excel
{
    static F_INSPECTION_NUMBER := "C2"
    static F_PART_NUMBER := "C4"
    static F_PART_DESCRIPTION := "C5"
    static F_LOT_NUMBER := "C6"
    static F_PO_NUMBER := "H3"
    static F_VENDOR_NAME := "H4"
    static F_PO_QUANTITY := "C10"
    static F_RECEIVED_QUANTITY := "H10"

    __New(filepath, isVisible := false)
    {
        base.__New(filepath, isVisible)
    }
}

inspReport := new InspectionReport("path/to/file")
inspReport.defaultSheet := "Sheet1"

inspReport.range[F_INSPECTION_NUMBER].value := 12345