unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tblocksize_form = class(TForm)
    set_block_bt: TButton;
    Label1: TLabel;
    Label2: TLabel;
    custom_block_edit: TEdit;
    block_dropdown: TComboBox;
    procedure set_block_btClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure block_dropdownChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  blocksize_form: Tblocksize_form;

implementation
uses variables;
{$R *.dfm}

procedure Tblocksize_form.set_block_btClick(Sender: TObject);
begin
        if block_dropdown.ItemIndex = (block_dropdown.Items.Count-1) then
        begin
                global_block_size := StrToInt(custom_block_edit.Text);
        end
        else
                global_block_size := block_value_list[block_dropdown.ItemIndex];
        begin
        end;

        Close;
end;

procedure Tblocksize_form.FormShow(Sender: TObject);
var i:Integer; custom_b:Boolean;
begin
        block_dropdown.Clear;
        custom_block_edit.Clear;
        custom_block_edit.Enabled := False;
        custom_b := True;

        //Listing the possible block size value in the dropdown list
        for i:=0 to block_value_list.Count-1 do
        begin
                //Correct spelling is always the best !
                if block_value_list[i] <= 1 then
                begin
                        block_dropdown.Items.Add(IntToStr(block_value_list[i])+' byte');
                end
                else
                begin
                        block_dropdown.Items.Add(IntToStr(block_value_list[i])+' bytes');
                end;

                if global_block_size = block_value_list[i] then
                begin
                        block_dropdown.ItemIndex := i;
                        custom_b := False;
                end;
        end;

       block_dropdown.Items.Add('Custom value');

       //Verifying if a custom value is used
       if custom_b then
       begin
                block_dropdown.ItemIndex := block_dropdown.Items.Count-1;
                custom_block_edit.Text := IntToStr(global_block_size);
                custom_block_edit.Enabled := True;
       end;
end;

procedure Tblocksize_form.block_dropdownChange(Sender: TObject);
begin
        if block_dropdown.ItemIndex = block_dropdown.Items.Count-1 then
        begin
                custom_block_edit.Enabled := True;
        end
        else
        begin
                custom_block_edit.Enabled := False;
        end;
end;

end.
