//    This file is part of SPR Utils.
//
//    You should have received a copy of the GNU General Public License
//    along with SPR Utils.  If not, see <http://www.gnu.org/licenses/>.

unit progress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmProgress = class(TForm)
    lblCurrentTask: TLabel;
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    btCancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

end.
