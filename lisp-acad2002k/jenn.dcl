jin_erase_text :dialog  {
  label="Erase of Selection Group";
  :column {
    :row {
      :button {
        label="���ڼ���";
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
      label="��ɽ��� �ٷΰ���";
      :column {
        :button {
          label="���ڸ�����";
          key="enn2";
        }
        :button {
          label="����������";
          key="enn3";
        }
        :button {
          label="�ߺ����ڵ�";
          key="enn_td";
        }
      }
      :column {
        :button {
          label="��ĭ������";
          key="enn4";
        }
        :button {
          label="�߽ɼ�����";
          key="enn5";
        }
        :button {
          label="�ߺ�������";
          key="enn_ld";
        }
      }
      :column {
        :button {
          label="LOCK LAYER";
          key="enn6";
        }
        :button {
          label="BLOCK ����";
          key="enn7";
        }
        :button {
          label="�ߺ�Block��";
          key="enn_bd";
        }
      }
    }
    :boxed_row {
      label="�������� �����ؼ� �����";
      :column {
        :button {
          label="����(Text)";
          key="enn_t";
        }
        :button {
          label="���(Block)";
          key="enn_b";
        }
      }
      :column {
        :button {
          label="��(Line)";
          key="enn_l";
        }
        :button {
          label="��(Circle)";
          key="enn_c";
        }
      }
      :column {
        :button {
          label="ĩ��(Dim)";
          key="enn_d";
        }
        :button {
          label="Pline";
          key="enn_p";
        }
      }
      :column {
        :button {
          label="Ÿ��(Arc)";
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
