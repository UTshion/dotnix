{ pkgs, ... }:

{
  xdg.desktopEntries = {
    dbeaver = {
      name = "DBeaver";
      comment = "SQL Database Tool";
      exec = "env GDK_BACKEND=x11 dbeaver";
      icon = "dbeaver";
      terminal = false;
      type = "Application";
      categories = [
        "Development"
        "Database"
      ];
      startupNotify = true;
      settings = {
        Keywords = "Database;SQL;IDE;JDBC;ODBC;MySQL;PostgreSQL;Oracle;DB2;MariaDB;";
      };
    };
    pureref = {
      name = "PureRef";
      genericName = "Reference Image Viewer";
      exec = "pureref %F";
      icon = "pureref";  # アイコンファイルがある場合はパスを指定
      comment = "Arrange and view reference images";
      categories = [ "Graphics" "Viewer" ];
      mimeType = [ "image/jpeg" "image/png" "image/bmp" "image/tiff" ];
      terminal = false;
    };
  };
}
