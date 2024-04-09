
dcl_settings : default_dcl_settings { audit_level = 0; }

XShow : dialog {
  label = "XData Viewer";
  : spacer {
  }
  : popup_list {
    label = "App Name";
    key = "applst";
    width = 20;
  }
  : spacer {
  }
  : list_box {
    label = "Code    Value";
    key = "xlst";
    width = 35;
  }
  : spacer {
  }
  : row {
    : button {
      label = "Display Another";
      key = "again";
      height = 2;
    }
    : button {
      label = "Done";
      key = "done";
      is_cancel = true;
      height = 2;
    }
  }
}
