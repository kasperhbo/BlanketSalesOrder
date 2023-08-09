pageextension 50351 "Blanket Sales Order Subform" extends "Blanket Sales Order Subform"
{

    actions
    {
        addfirst("F&unctions")
        {
            group("Hellebreker Functions")
            {
                action("Get Item By Enviroment, Strength Class and Consistention")
                {
                    // // AccessByPermission = TableData "Sales Price" = R;
                    ApplicationArea = Suite;
                    Caption = 'Get Item By Enviroment, Strength Class and Consistention';
                    Ellipsis = true;
                    Image = AnalysisViewDimension;
                    Visible = true;
                    ToolTip = 'Insert the lowest possible price in the Unit Price field according to any special price that you have set up.';
                    // // ObsoleteState = Pending;
                    // // ObsoleteTag = '19.0';
                    // // ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    trigger OnAction()
                    begin

                    end;
                }
            }
        }
    }
}
