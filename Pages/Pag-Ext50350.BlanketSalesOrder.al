pageextension 50350 "Blanket Sales Order" extends "Blanket Sales Order"
{
    layout
    {
        addafter("Campaign No.")
        {
            field("Rayon No."; Rec."Rayon No.")
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies the rayon number that the document is linked to.';
                trigger OnValidate()
                begin
                    Rec.UpdateSalesLines();
                end;
            }

            field("Project No."; Rec.Project)
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies the project number that the document is linked to.';
                trigger OnValidate()
                begin
                    Rec.UpdateSalesLines();
                end;
            }
        }
    }

}
