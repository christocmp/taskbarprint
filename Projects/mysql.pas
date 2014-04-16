unit mysql;

interface
uses
  ActiveX,
  DB,
  SysUtils;


function CreateDatabase(Database:string) : string;

implementation

function CreateDatabase(Database:string) : string;
var output : string;
begin
  output := 'Creating Database '+database;
  //AdoConnection.Execute('CREATE DATABASE IF NOT EXISTS '+Database,cmdText);
  output := output +  ('Database '+database+' created');
  result := output;
end;

end.
