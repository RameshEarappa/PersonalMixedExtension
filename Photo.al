table 50104 Photo
{
    Permissions = tabledata Photo = rimd;
    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; Name; Code[20])
        {

        }
        field(3; Picture; Blob)
        {
            Caption = 'Picture';
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        Comp: Record "Gen. Journal Line";
        Com: Page "Item Card";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure UploadImage(DocumentInstream: InStream)
    var
        Ostream: OutStream;
    begin
        Rec.Picture.CreateOutStream(Ostream);
        CopyStream(Ostream, DocumentInstream);
        Rec.Insert(true);
    end;

}

page 50104 "SI"
{
    PageType = CardPart;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field(SaleDateName1; SaleDateName[1])
                {

                }
                field(SaleDateName2; SaleDateName[2])
                {

                }
                field(QtySold1; QtySold[1])
                {
                    ApplicationArea = All;
                    Caption = 'Qty(MTD)';
                }
                field(QtySold2; QtySold[2])
                {
                    ApplicationArea = All;
                    Caption = 'Qty(YTD)';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        DateFilterCalc.CreateAccountingPeriodFilter(SaleDateFilter[1], SaleDateName[1], WorkDate(), 0);
        DateFilterCalc.CreateFiscalYearFilter(SaleDateFilter[2], SaleDateName[2], WorkDate(), 0);

        Clear(QtySold);

        for I := 1 To 2 DO begin
            SetFilter("Date Filter", SaleDateFilter[I]);
            CalcFields("Sales (Qty.)");
            QtySold[I] := "Sales (Qty.)";
        end;
    end;

    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        SaleDateFilter: array[2] of Text[30];
        SaleDateName: array[2] of Text[30];
        I: Integer;
        QtySold: array[2] of Decimal;
}

pageextension 50119 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Attached Documents")
        {
            part(SI; SI)
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}