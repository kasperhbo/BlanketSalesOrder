codeunit 50350 SalesHeaderEventHandler
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterUpdateUnitPrice, '', false, false)]
    procedure OnAfterUpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer);
    var
        SalesHeaderRec: Record "Sales Header";
        PriceListHeader: Record "Price List Header";
        PriceListLines: Record "Price List Line";
    begin
        if SalesHeaderRec.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            if CheckProject(SalesLine, SalesHeaderRec, PriceListHeader, PriceListLines) then begin
                exit;
            end
            else
                if CheckRayon(SalesLine, SalesHeaderRec, PriceListHeader, PriceListLines) then begin
                    exit;
                end;
        end;
    end;

    procedure CheckRayon(
        var SalesLine: Record "Sales Line"; SalesHeaderRec: Record "Sales Header";
        PriceListHeader: Record "Price List Header";
        PriceListLines: Record "Price List Line"): Boolean;
    begin
        //Check if the Sales Header has a Job
        SalesLine."Line Discount %" := 0;
        SalesLine.ValidateLineDiscountPercent(true);

        if SalesHeaderRec."Rayon No." <> '' then begin
            PriceListHeader.SETFILTER("Assign-to No.", '%1', SalesHeaderRec."Rayon No.");
            if PriceListHeader.FINDSET then
                repeat
                    // Filter PriceListLines by the current PriceListHeader
                    PriceListLines.SETRANGE("Price List Code", PriceListHeader."Code"); // Assuming the relation is by a "No." field

                    // Construct and display the message for each PriceListLine
                    if PriceListLines.FINDSET then
                        repeat
                            if PriceListLines."Product No." = SalesLine."No." then begin
                                SalesLine."Line Discount %" := PriceListLines."Line Discount %";
                                SalesLine.ValidateLineDiscountPercent(true);
                            end;
                        until PriceListLines.NEXT = 0;

                until PriceListHeader.NEXT = 0;
            exit(true);
        end;
        exit(false);
    end;

    procedure CheckProject(
        var SalesLine: Record "Sales Line"; SalesHeaderRec: Record "Sales Header";
        PriceListHeader: Record "Price List Header";
        PriceListLines: Record "Price List Line"): Boolean;
    begin
        if SalesHeaderRec.Project <> '' then begin
            PriceListHeader.SETFILTER("Assign-to No.", '%1', SalesHeaderRec.Project);
            if PriceListHeader.FINDSET then
                repeat
                    // Filter PriceListLines by the current PriceListHeader
                    PriceListLines.SETRANGE("Price List Code", PriceListHeader."Code"); // Assuming the relation is by a "No." field

                    // Construct and display the message for each PriceListLine
                    if PriceListLines.FINDSET then
                        repeat
                            if PriceListLines."Product No." = SalesLine."No." then begin
                                SalesLine."Line Discount %" := PriceListLines."Line Discount %";
                                SalesLine.ValidateLineDiscountPercent(true);
                            end;
                        until PriceListLines.NEXT = 0;

                until PriceListHeader.NEXT = 0;
            exit(true);
        end;
        exit(false);
    end;
}
