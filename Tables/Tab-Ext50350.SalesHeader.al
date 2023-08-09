tableextension 50350 "Sales Header" extends "Sales Header"
{
    fields
    {
        field(50350; "Rayon No."; Code[20])
        {
            Caption = 'Rayon';
            DataClassification = CustomerContent;
            TableRelation = Rayon;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                isSet: Boolean;
            begin
                isSet := RayonLookUpOK("Rayon No.");
                if not isSet then begin
                    // ERROR('Rayon is not set for this customer');
                    //Do some error/reseting handling here in the future
                end
                else begin
                    Message('Rayon is set for this custome With no: ' + Rec."Rayon No.");
                    UpdateSalesLines();
                end;
            end;
        }

        field(50351; Project; Code[20])
        {
            Caption = 'Project';
            DataClassification = CustomerContent;
            TableRelation = CustomerProject;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                isSet: Boolean;
            begin
                isSet := CustomerProjectLookUpOK(Project);
                if not isSet then begin
                    // ERROR('Project is not set for this customer');
                    //Do some error/reseting handling here in the future
                end
                else begin
                    Message('Project is set for this custome With no: ' + Rec.Project);
                    UpdateSalesLines();
                end;
            end;
        }
    }

    procedure UpdateSalesLines()
    var
        SalesLineRec: Record "Sales Line";
    begin
        SalesLineRec.SetRange("Document Type", rec."Document Type");
        SalesLineRec.SetRange("Document No.", rec."No.");

        if SalesLineRec.FindSet then begin
            repeat
                UpdatePrices(SalesLineRec, Rec);
            until SalesLineRec.Next() = 0;
        end;
    end;

    procedure UpdatePrices(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header")
    var
        PriceListHeader: Record "Price List Header";
        PriceListLines: Record "Price List Line";
    begin
        if (Rec."Rayon No." <> '') then begin
            UpdatePriceByRecord(PriceListHeader, PriceListLines, SalesLine, SalesHeader, Rec."Rayon No.");
        end else
            if (Rec.Project <> '') then begin
                UpdatePriceByRecord(PriceListHeader, PriceListLines, SalesLine, SalesHeader, Rec.Project);
            end;
    end;

    procedure UpdatePriceByRecord(var PriceListHeader: Record "Price List Header"; var PriceListLines: Record "Price List Line";
                                 var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header";
                                 RecordToNo: Code[20])
    begin
        PriceListHeader.SETRANGE("Assign-to No.", RecordToNo);

        if PriceListHeader.FINDSET then begin
            repeat
                PriceListLines.SETRANGE("Price List Code", PriceListHeader."Code");
                if PriceListLines.FINDSET then begin
                    repeat
                        if PriceListLines."Product No." = SalesLine."No." then begin
                            SalesLine."Line Discount %" := PriceListLines."Line Discount %";
                            SalesLine.Modify();
                        end;
                    until PriceListLines.NEXT = 0;
                end;
            until PriceListHeader.NEXT = 0;
        end;
    end;

    procedure RayonLookUpOK(var Rayon: Code[20]): Boolean
    var
        // rayonRec: Record Rayon;
        rayonLookUpPage: Page RayonLookup;
        rec: Record Rayon;
    begin
        if rayonLookUpPage.LookupMode(true) then;
        if rayonLookUpPage.RunModal() = ACTION::LookupOK then begin
            rayonLookUpPage.GetRecord(rec);
            Rayon := rec."RayonNO.";
            exit(true);
        end else
            exit(false);
    end;

    procedure CustomerProjectLookupOK(var CustomerProject: Code[20]): Boolean
    var
        // rayonRec: Record Rayon;
        customerLookUpPage: Page CustomerProjectLookup;
        rec: Record CustomerProject;
    begin
        if customerLookUpPage.LookupMode(true) then;
        if customerLookUpPage.RunModal() = ACTION::LookupOK then begin

            //Check if the project is active in the sales header
            customerLookUpPage.GetRecord(rec);
            CustomerProject := rec."ProjectNO.";

            exit(true);
        end else
            exit(false);
    end;
}
