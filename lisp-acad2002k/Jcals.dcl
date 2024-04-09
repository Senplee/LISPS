jincals :dialog  {
  label="Calcuration's Drawing-Text";
    :boxed_row {
      :boxed_column {
        label="Select of Calcuration Option's";
        :button {
            label="Calcuration Only (Drawing-Text)";
            key="cals1";
          }
        :button {
            label="MCC-Load Calcuration (??/??)";
            key="cals2";
          }
        :button {
            label="Ampear Calcuration (??/??v=??A)";
            key="cals3";
          }
        :button {
            label="Calcuration Only (Text-Change)";
            key="cals4";
          }
        :button {
            label="(60%=Recep)+(100%=Other) Calcuration";
            key="cals5";
          }
        :button {
            label="Demand-load / Total-load Calcuration";
            key="cals6";
          }
        :button {
            label="60% Calcuration (load*0.6)-> one by one";
            key="cals7";
          }
        :spacer { width=2; }
      }
      :boxed_column {
        label="Set";
        :radio_button {
           key="cals_b1";
          }
        :radio_button {
           key="cals_b2";
          }
        :radio_button {
           key="cals_b3";
          }
        :radio_button {
           key="cals_b4";
          }
        :radio_button {
           key="cals_b5";
          }
        :radio_button {
           key="cals_b6";
          }
        :radio_button {
           key="cals_b7";
          }
        :spacer { width=2; }
      }
    }
  ok_cancel;
}
