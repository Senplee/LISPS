jinlist_li :dialog  {
  label="  * List Prompt-Box [LINE] *  ";
  :row {
    :boxed_column {
      label="Type,Layer,Color,Ltype";
      :row {
        :button {
          label="Type ";
          key="del1";
          fixed_width=true;
        }
        :edit_box {
          label="";
          key="jli0";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Layer";
          key="ch_la";
          fixed_width=true;
        }
        :edit_box {
          key="jli8";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="ch_co";
          fixed_width=true;
        }
        :edit_box {
          key="jli62";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Ltype";
          key="ch_lt";
          fixed_width=true;
        }
        :edit_box {
          key="jli6";
          edit_width=15;
        }
      }
    }
    :boxed_column {
      label="Distance,Angle";
      :row {
        :button {
          label="�� ��";
          key="del2";
          fixed_width=true;
        }
        :edit_box {
          key="jli12";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="del3";
          fixed_width=true;
        }
        :edit_box {
          key="jlia";
          edit_width=15;
        }
      }
      :button {
        label=" ";
      }
      :button {
        label="--< Park D.S >--";
        key="pds_key";
      }
    }
  }
  :boxed_column {
    label="Start & End Point...";
    :edit_box {
      label="Start Point (X,Y,Z)";
      key="jli10";
    }
    :edit_box {
      label="End Point (X,Y,Z)  ";
      key="jli11";
    }
  }
  :boxed_row {
    label="Line Change......";
    :button {
      label="Change Point";
      key="ch_po";
    }
  }
  ok_cancel;
}

jinlist_bl :dialog  {
  label="  * List Prompt-Box [BLOCK] *  ";
  :row {
    :boxed_column {
      label="Type,Name,Layer,Angle";
      :row {
        :button {
          label="Type ";
          key="del1";
        }
        :edit_box {
          key="jli0";
          edit_width=12;
        }
      }
      :row {
        :button {
          label="Name ";
          key="del2";
        }
        :edit_box {
          key="jli2";
          edit_width=12;
        }
      }
      :row {
        :button {
          label="Layer";
          key="ch_la";
        }
        :edit_box {
          key="jli8";
          edit_width=12;
        }
      }
      :row {
        :button {
          label="ȸ����";
          key="del3";
        }
        :edit_box {
          key="jli50";
          edit_width=12;
        }
      }
    }
    :boxed_column {
      label="Block's Insert Scale";
      :edit_box {
        label="X-��ô :";
        key="jli41";
      }
      :edit_box {
        label="Y-��ô :";
        key="jli42";
      }
      :edit_box {
        label="Z-��ô :";
        key="jli43";
      }
      :button {
        label="--< Park D.S >--";
        key="pds_key";
      }
    }
  }
  :boxed_row {
    label="Block Insert Point";
    :edit_box {
      label="Insert Point";
      key="jli10";
    }
  }
  :boxed_row {
    label="Block Change......";
    :button {
      label=" S7 ";
      key="ch_s7";
    }
    :button {
      label="Point";
      key="ch_po";
    }
    :button {
      label="Explode";
      key="ch_ep";
    }
  }
  ok_cancel;
}

jinlist_ci :dialog  {
  label="* List Prompt-Box [CIRCLE] *";
  :row {
    :boxed_column {
      label="Type,Layer,Color";
      :row {
        :button {
          label="Type  ";
          key="del1";
        }
        :edit_box {
          key="jli0";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Layer ";
          key="ch_la";
        }
        :edit_box {
          key="jli8";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="ch_co";
        }
        :edit_box {
          key="jli62";
          edit_width=15;
        }
      }
    }
    :boxed_column {
      label="Ltype,Radious";
      :row {
        :button {
          label="Ltype ";
          key="ch_lt";
        }
        :edit_box {
          key="jli6";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="������";
          key="ch_po";
        }
        :edit_box {
          key="jli40";
          edit_width=15;
        }
      }
      :button {
        label="--< Park D.S >--";
        key="pds_key";
      }
    }
  }
  :boxed_row {
    label="Center Point (X,Y,Z)";
    :edit_box {
      key="jli10";
    }
  }
  ok_cancel;
}

jinlist_te :dialog  {
  label=" * List Prompt-Box [TEXT, MTEXT] * ";
  :row {
    :boxed_column {
      label="Type,Layer,Color,Start";
      :row {
        :button {
          label="Type ";
          key="del1";
          fixed_width=true;
        }
        :edit_box {
          key="jli0";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Layer";
          key="ch_la";
          fixed_width=true;
        }
        :edit_box {
          key="jli8";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="ch_co";
          fixed_width=true;
        }
        :edit_box {
          key="jli62";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="������";
          key="del6";
          fixed_width=true;
        }
        :edit_box {
          key="jli7x";
          edit_width=15;
        }
      }
    }
    :boxed_column {
      label="Style,Font,Hight,Width";
      :row {
        :button {
          label="�� ��";
          key="ch_te54";
          fixed_width=true;
        }
        :edit_box {
          key="jli7";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� Ʈ";
          key="del3";
          fixed_width=true;
        }
        :edit_box {
          key="jlift";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="del4";
          fixed_width=true;
        }
        :edit_box {
          key="jli40";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="del5";
          fixed_width=true;
        }
        :edit_box {
          key="jli41";
          edit_width=15;
        }
      }
    }
  }
  :boxed_row {
    label="Text Start Point...";
    :edit_box {
      label="Start Point (X,Y,Z)";
      key="jli10";
    }
  }
  :boxed_row {
    label="Text Description is...";
    :edit_box {
      key="jli1";
    }
  }
  :boxed_row {
    label="Text Change......";
    :button {
      label="Text";
      key="ch_te";
    }
    :button {
      label="Point";
      key="ch_po";
    }
  }
  ok_cancel;
}


jinlist_di :dialog  {
  label=" * List Prompt-Box [DIMMENSION] * ";
  :row {
    :boxed_column {
      label="Type,Layer,Color,Ltype";
      :row {
        :button {
          label="Type ";
          key="del1";
          fixed_width=true;
        }
        :edit_box {
          key="jli0";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Layer";
          key="ch_la";
          fixed_width=true;
        }
        :edit_box {
          key="jli8";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="ch_co";
          fixed_width=true;
        }
        :edit_box {
          key="jli62";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Ltype";
          key="ch_lt";
          fixed_width=true;
        }
        :edit_box {
          key="jli6";
          edit_width=15;
        }
      }
    }
    :boxed_column {
      label="Distance,Value";
      :row {
        :button {
          label="ġ������";
          key="del2";
          fixed_width=true;
        }
        :edit_box {
          key="jli12";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="ǥ�ð���";
          key="ch_va";
          fixed_width=true;
        }
        :edit_box {
          key="jli1";
          edit_width=15;
        }
      }
      :button {
        label=" ";
      }
      :button {
        label="--< Park D.S >--";
        key="pds_key";
      }
    }
  }
  :boxed_column {
    label="Dimension's Start & End Point";
    :edit_box {
      label="Start Point (X,Y,Z)";
      key="jli13";
    }
    :edit_box {
      label="End Point (X,Y,Z)  ";
      key="jli14";
    }
  }
  :boxed_row {
    label="Dim Change......";
    :button {
      label="Explode";
      key="ch_ep";
    }
  }
  ok_cancel;
}

jinlist_pl :dialog  {
  label="* List Prompt-Box [PLINE] *";
  :row {
    :boxed_column {
      label="Type,Layer,Color,Ltype";
      :row {
        :button {
          label="Type ";
          key="del1";
//          fixed_width=true;
        }
        :edit_box {
          key="jli0";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Layer";
          key="ch_la";
//          fixed_width=true;
        }
        :edit_box {
          key="jli8";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="�� ��";
          key="ch_co";
//          fixed_width=true;
        }
        :edit_box {
          key="jli62";
          edit_width=15;
        }
      }
      :row {
        :button {
          label="Ltype";
          key="ch_lt";
//          fixed_width=true;
        }
        :edit_box {
          key="jli6";
          edit_width=15;
        }
      }
    }
    :boxed_column {
      label="Pline's Width";
      :button {
        label="�� ��";
      }
      :edit_box {
        label="����";
        key="jli40";
      }
      :edit_box {
        label="����";
        key="jli41";
      }
      :button {
        label="--< Park D.S >--";
        key="pds_key";
      }
    }
  }
  :boxed_row {
    label="Pline Change......";
    :button {
      label="Explode";
      key="ch_ep";
    }
  }
  ok_cancel;
}

