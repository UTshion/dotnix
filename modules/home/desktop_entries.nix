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
  };
}
