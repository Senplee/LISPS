jinsing :dialog  {
  label="Singleline Diagram Calcuration Box";
  :column {
    :boxed_column {
      label="Incomming Zone";
      :edit_box {
          label="Main Fuse-Rate :";
          key="jmain_f";
          value=100.0;
          width=7;
      }
      :edit_box {
          label="M.O.F CT-Rate :";
          key="jmof_ct";
          value=1.0;
          width=7;
      }
      :edit_box {
          label="V.C.B Frame-Rate :";
          key="jvcb_f";
          value=1.0;
          width=7;
      }
    }
    :boxed_row {
       label="Transformer Zone ";
         :boxed_column {
            label="TR #1 ";
	    :edit_box {
	       label="CT-Rate :";
	       key="jct_tr1";
	       value=1.0;
	       width=7;
	    }
	    :edit_box {
	       label="Capacitor-Rate :";
	       key="jcap_tr1";
	       value=1.0;
	       width=7;
	    }
	    :edit_box {
	       label="MCCB for Cap. :";
	       key="jmccb_tr1";
	       value=1.0;
	       width=7;
	    }
	    :edit_box {
	       label="A.C.B Frame-Rate :";
	       key="jacb_tr1";
	       value=1.0;
	       width=7;
	    }
         }
      }
      :spacer { width=1; }
    }
  }
  ok_cancel;
}
