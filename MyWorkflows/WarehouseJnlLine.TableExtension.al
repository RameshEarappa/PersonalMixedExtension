tableextension 50105 "Extend Warehouse Jnl" extends "Warehouse Journal Line"
{
    fields
    {
        field(50250; Status; Enum "Physical Inventory Journal WF")
        {
            DataClassification = ToBeClassified;
        }
        field(50251; "WF Instance ID"; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(50252; OptionType; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open;
        }
        field(50253; "Request Approved LT"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Request Approved';
        }
    }
}