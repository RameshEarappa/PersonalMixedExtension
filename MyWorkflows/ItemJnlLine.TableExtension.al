tableextension 50102 "Extend Item Jnl. Line" extends "Item Journal Line"
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
    }
}