jincub :dialog  {
  label="Drawing of Pane-Plan or Diagram";
    :boxed_column {
      label="Select of Cubicle";
      :button {
          label="LV = Low-Voltage Panel    ";
          key="lvp";
        }
      :button {
          label="TR = Transformer Panel    ";
          key="trp";
        }
      :button {
          label="SH = High-Voltage Panel   ";
          key="shp";
        }
      :button {
          label="MCC = Motor Control Center";
          key="mcc";
        }
      :spacer { width=2; }
    }
    :spacer { width=2; }
    :boxed_column {
      label="Cubicl's Door Select";
      :button {
          label="LV Panel's Door";
          key="cdrl";
        }
      :button {
          label="TR Panel's Door";
          key="cdrt";
        }
      :button {
          label="SH Panel's Door";
          key="cdrs";
        }
      :spacer { width=2; }
    }
    :spacer { width=2; }
    :boxed_column {
      label="Select of Diagram";
      :button {
          label="MCC Diagram";
          key="mdia";
        }
      :button {
          label="PNL Diagram";
          key="pdia";
        }
      :spacer { width=2; }
    }
  ok_cancel;
}
