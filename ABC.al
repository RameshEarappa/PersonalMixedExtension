report 60098 "Test Report"
{
    Caption = 'Test Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Kinduct Sales\Reports\Test.rdl';

    dataset
    {
        dataitem("Revenue Recognition Schedule"; "Revenue Recognition Schedule")
        {

            DataItemTableView = SORTING("Sales Order No.", "SO Line No.", "Line No.") ORDER(Ascending);
            RequestFilterFields = "Customer No.", "Sales invoice No.";
            column(DeferralSummarySalesCaption; DeferralSummarySalesCaptionLbl) { }
            column(PageGroupNo; PageGroupNo) { }
            column(PageCaption; PageCaptionLbl) { }
            column(BalanceAsOfDateCaption; BalanceAsOfDateCaptionLbl + Format(Balanceasof)) { }
            column(AmtRecognizedCaption; AmtRecognizedLbl) { }
            column(RemAmtDefCaption; RemAmtDefCaptionLbl) { }
            column(TotAmtDefCaption; TotAmtDefCaptionLbl) { }
            column(PostingDate; "Posting Date") { }
            column(Document_No; "Sales invoice No.") { }
            column(SO_Line_No; "SO Line No.") { }
            column(DocumentTypeString; 'Posted Invoice') { }
            column(LineType; Type) { }
            column(LineDescription; "Item Description") { }
            column(DeferralAccount; "Deferral Account") { }
            column(NumOfPeriods; Noofperiods) { }
            column(AmtRecognized; AmtRecognized) { }
            column(RemainingAmtDeferred; RemainingAmtRecognized) { }
            column(CustNo; "Customer No.") { }
            column(CustName; "Customer Name") { }
            column(CompanyName; COMPANYPROPERTY.DisplayName) { }

            trigger OnAfterGetRecord()
            var
                SalesInvoiceLineL: Record "Sales Invoice Line";
                RevenueRecogSchedule: Record "Revenue Recognition Schedule";
                RevenueRecogSchedule1: Record "Revenue Recognition Schedule";
            begin
                Clear(Type);
                SalesInvoiceLineL.SetRange("Document No.", "Revenue Recognition Schedule"."Sales invoice No.");
                SalesInvoiceLineL.SetRange("Line No.", "Revenue Recognition Schedule"."SO Line No.");
                if SalesInvoiceLineL.FindFirst() then begin
                    Type := format(SalesInvoiceLineL.Type);
                    Noofperiods := SalesInvoiceLineL."Deferral Code";
                end;

                Clear(AmtRecognized);
                RevenueRecogSchedule.SetRange("Sales invoice No.", "Revenue Recognition Schedule"."Sales invoice No.");
                RevenueRecogSchedule.SetRange("SO Line No.", "Revenue Recognition Schedule"."SO Line No.");
                RevenueRecogSchedule.SetRange(Posted, true);
                if RevenueRecogSchedule.FindSet() then
                    repeat
                        AmtRecognized := AmtRecognized + RevenueRecogSchedule.Amount;
                    until RevenueRecogSchedule.Next() = 0;

                Clear(RemainingAmtRecognized);
                RevenueRecogSchedule1.SetRange("Sales invoice No.", "Revenue Recognition Schedule"."Sales invoice No.");
                RevenueRecogSchedule1.SetRange("SO Line No.", "Revenue Recognition Schedule"."SO Line No.");
                RevenueRecogSchedule1.SetRange(Posted, false);
                if RevenueRecogSchedule1.FindSet() then
                    repeat
                        RemainingAmtRecognized := RemainingAmtRecognized + RevenueRecogSchedule1.Amount;
                    until RevenueRecogSchedule1.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Balanceasof; Balanceasof)
                    {
                        ApplicationArea = All;
                        Caption = 'Balance as of:';
                    }
                }
            }
        }
        trigger OnOpenPage()
        begin
            if Balanceasof = 0D then
                Balanceasof := WorkDate;
        end;
    }
    labels
    {
        PostingDateCaption = 'Posting Date';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        EntryNoCaption = 'Entry No.';
        NoOfPeriodsCaption = 'No. of Periods';
        DeferralAccountCaption = 'Deferral Account';
        DocTypeCaption = 'Document Type';
        DefStartDateCaption = 'Deferral Start Date';
        AcctNameCaption = 'Account Name';
        LineNoCaption = 'Line No.';
        CustNoCaption = 'Customer No.';
        CustNameCaption = 'Customer Name';
        LineDescCaption = 'Line Description';
        LineTypeCaption = 'Line Type';
    }
    var
        DeferralSummarySalesCaptionLbl: Label 'Deferral Summary - Sales';
        BalanceAsOfDateCaptionLbl: Label 'Balance as of: ';
        AmtRecognizedLbl: Label 'Amt. Recognized';
        RemAmtDefCaptionLbl: Label 'Remaining Amt. Deferred';
        TotAmtDefCaptionLbl: Label 'Total Amt. Deferred';
        PageCaptionLbl: Label 'Page';
        PageGroupNo: Integer;
        AmtRecognized: Decimal;
        RemainingAmtRecognized: Decimal;
        Type: Text;
        Noofperiods: Code[10];
        CompInfo: Record "Company Information";
        Balanceasof: Date;
}