jin_erase_text :dialog  {
  label="Erase of Selection Group";
  :column {
    :row {
      :button {
        label="문자선택";
        key="enn1_s";
		  is_tab_stop=false;
      }
      :edit_box {
        key="enn1";
        value="";
        width=20;
      }
//      :spacer { width=1; }
    }
    :boxed_row {
      label="명령실행 바로가기";
      :column {
        :button {
          label="숫자를지움";
          key="enn2";
        }
        :button {
          label="공백을지움";
          key="enn3";
        }
        :button {
          label="중복문자들";
          key="enn_td";
        }
      }
      :column {
        :button {
          label="빈칸을지움";
          key="enn4";
        }
        :button {
          label="중심선지움";
          key="enn5";
        }
        :button {
          label="중복선지움";
          key="enn_ld";
        }
      }
      :column {
        :button {
          label="LOCK LAYER";
          key="enn6";
        }
        :button {
          label="BLOCK 지움";
          key="enn7";
        }
        :button {
          label="중복Block들";
          key="enn_bd";
        }
      }
    }
    :boxed_row {
      label="같은종류 선택해서 지우기";
      :column {
        :button {
          label="문자(Text)";
          key="enn_t";
        }
        :button {
          label="블록(Block)";
          key="enn_b";
        }
      }
      :column {
        :button {
          label="선(Line)";
          key="enn_l";
        }
        :button {
          label="원(Circle)";
          key="enn_c";
        }
      }
      :column {
        :button {
          label="칫수(Dim)";
          key="enn_d";
        }
        :button {
          label="Pline";
          key="enn_p";
        }
      }
      :column {
        :button {
          label="타원(Arc)";
          key="enn_a";
        }
        :button {
          label="Command";
          key="enn_xx";
        }
      }
	 }	
  }
  ok_cancel;
}
