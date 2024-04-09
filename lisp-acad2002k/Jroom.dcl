jinroom :dialog  {
  label="Lighting Block Array";
  :row {
    :boxed_column {
      label="Calcuration's Room Lux";
      :row {
        :boxed_column {
          label="Room's Setting";
			:text {
				label="가로폭 :";
				key="room_w";
			}
			:text {
				label="세로폭 :";
				key="room_l";
			}
			:text {
				label="실면적 :";
				key="room_a";
			}
          :edit_box {
            label="등높이 :";
            key="room_h";
          }
          :text {
            label="실지수 :";
            key="room_d";
          }
          :edit_box {
            label="요구조도 :";
            key="room_lux";
          }
        }
        :boxed_column {
          label="Calcuration is...";
          :edit_box {
            label="보수율 :";
            key="room_f";
          }
          :edit_box {
            label="조명율 :";
            key="room_u";
          }
          :edit_box {
            label="등광속 :";
            key="room_lum";
          }
          :edit_box {
            label="계산수량 :";
            key="room_ea";
          }
          :text {
            label="계산조도 :";
            key="room_cal";
          }
          :text {
            label="백분율[%] :";
            key="room_pus";
          }
        }
      }
      :boxed_row {
        label="Detector Calcuration *(default=DETD)";
        :edit_box {
          label="4M 이하일때 :";
          key="room_det_u";
        }
        :edit_box {
          label="4M 초과할때:";
          key="room_det_o";
        }
      }
    }
    :boxed_column {
      label="Light Array";
      :boxed_column {
        label="Fixture Plan";
        :row {
          :column {
            fixed_height=true;
            :button {
              label="Type";
              key="img_ty";
              fixed_width=true;
            }
            :spacer { width=0; }
          }
          :image {
            key="ltg_img";
            color=0;
            width=9;
            height=3;
          }
        }
        :edit_box {
          label="Name:";
          key="jblm";
          value="FL240";
          width=9;
        }
      }
      :boxed_column {
        label="Option's";
        :button {
          label="Number's";
          key="jxno";
        }
        :button {
          label="Distance";
          key="jxdi";
        }
        :button {
          label="Only One";
          key="jsin";
        }
        :button {
          label=" --< Park D.S >-- ";
          key="pds_key";
        }
      }
    }
  }
  ok_cancel;
}

jinroom_ltg :dialog {
  label="Lighting Fixture Type Select";
  :row {
    :boxed_column {
      label="FL-Normal";
      :button {
        label="FL120";
        key="fl120";
      }
      :button {
        label="FL220";
        key="fl220";
      }
      :button {
        label="FPL336A";
        key="fpl336A";
      }
      :button {
        label="FL132";
        key="fl132";
      }
      :button {
        label="FL232";
        key="fl232";
      }
      :button {
        label="FL332";
        key="fl332";
      }
      :button {
        label="FL436A";
        key="fl436a";
      }
    }
    :boxed_column {
      label="FL-Emer..";
      :button {
        label="FL120E";
        key="fl120e";
      }
      :button {
        label="FL220E";
        key="fl220e";
      }
      :button {
        label="FPL336AE";
        key="fpl336ae";
      }
      :button {
        label="FL132e";
        key="fl132e";
      }
      :button {
        label="FL232E";
        key="fl232e";
      }
      :button {
        label="FL332E";
        key="fl332e";
      }
      :button {
        label="FPL436AE";
        key="fpl436ae";
      }
    }
    :boxed_column {
      label="IL.......";
      :button {
        label="FPL213";
        key="fpl213";
      }
      :button {
        label="FPL213E";
        key="fpl213e";
      }
      :button {
        label="IL60";
        key="il60";
      }
      :button {
        label="IL60E";
        key="il60e";
      }
      :button {
        label="IL60B";
        key="il60b";
      }
      :button {
        label="IL60BE";
        key="il60be";
      }
      :button {
        label="ILO1";
        key="ilo1";
      }
    }
    :boxed_column {
      label="Other....";
      :button {
        label="DETD";
        key="detd";
      }
      :button {
        label="DETS";
        key="dets";
      }
      :button {
        label="DETC";
        key="detc";
      }
    }
  }
  :row {
    :edit_box {
      label="Block Name is:";
      key="ltg_sel";
      width=10;
      allow_accept=true;
    }
    :button {
      label=" --< Park D.S >-- ";
//      key="pds_key";
    }
  }
  ok_only;
}
