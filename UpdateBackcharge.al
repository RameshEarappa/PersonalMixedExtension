report 50138 "Update Backcharge"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = rm;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                if UploadIntoStream('Select Excel File to Import', '', '', FileName, FileInStream) then begin
                    SheetName := ExcelBuf.SelectSheetsNameStream(FileInStream);
                    ExcelBuf.LOCKTABLE;
                    ExcelBuf.OpenBookStream(FileInStream, SheetName);
                    ExcelBuf.ReadSheet;
                    GetLastRowandColumn;
                    FOR X := 2 TO TotalRows DO
                        InsertData(X);
                    ExcelBuf.DELETEALL;
                end;
            end;
        }
    }
    trigger OnPostReport()
    begin
        MESSAGE('Import Completed');
    end;

    var
        ExcelBuf: Record "Excel Buffer";
        ExcelBuf1: Record "Excel Buffer";
        ExcelImport: Record "G/L Entry";
        TotalCols: Integer;
        TotalRows: Integer;
        FileName: Text;
        FileInStream: InStream;
        SheetName: Text;
        X: Integer;

    PROCEDURE GetLastRowandColumn();
    BEGIN
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalCols := ExcelBuf.COUNT;
        ExcelBuf.RESET;
        TotalRows := ExcelBuf."Row No.";
    END;

    local procedure InsertData(RowNo: Integer)
    begin
        ExcelImport.SetRange("Document No.", GetValueAtCell(RowNo, 1));
        ExcelImport.SetRange("Source Code", 'PURCHASES');
        if ExcelImport.FindSet() then begin
            repeat
                if GetValueAtCell(RowNo, 2) <> '' then
                    ExcelImport.Validate(Backcharge, GetValueAtCell(RowNo, 2));
                if GetValueAtCell(RowNo, 3) <> '' then
                    ExcelImport.Validate("Backcharge To", GetValueAtCell(RowNo, 3));
                ExcelImport.Modify(true);
            until ExcelImport.Next() = 0;
        end;
    end;

    PROCEDURE GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    BEGIN
        IF ExcelBuf1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuf1."Cell Value as Text");
    END;
}