//������ (�����Ǽ� or ����ȹ tel:02-324-1456) �� ���� �ؽ�Ʈ���ڸ� 
//�Ϸ������� �־��� ���� +,-,/,x �ϴ� �����Դϴ�.
//�ǹ����̳� �߸������� ������ ���� ��ȭ�� �����ϰų�
//�����ּ���. ������id:xoutside
union:dialog {
      label = "�ؽ�Ʈ ���ڿ� -,+,/,* �Ϸ������� �ϱ�";
         initial_focus = "ebox";
       :row{
        label="������";
       :radio_button{
        label=" + ";
        key="button+";
        }
       :radio_button{
        label=" -- ";
        key="button-";
        }
       :radio_button{
        label=" / ";
        key="button/";
        }
       :radio_button{
        label=" X ";
        key="button*";
        }
       }
       spacer;
       :row{
        label="�Ҽ��� �ڸ���";
       :radio_button{
        label=" 0 ";
        key="button0";
        }
       :radio_button{
        label=" 1 ";
        key="button1";
        }
       :radio_button{
        label=" 2 ";
        key="button2";
        }
       :radio_button{
        label=" 3 ";
        key="button3";
        }
       :radio_button{
        label=" 4 ";
        key="button4";
        }
       :radio_button{
        label=" 5 ";
        key="button5";
        }
       }
       
       :row {
        :list_box{         key="lbox1";width=17;           fixed_width = true; }
        :text {label="   "; key = "total";}
        :edit_box{
       //label="Scale:";
         key="ebox";

         width=8;
         }
        :text {label="=";}
        :list_box{key="lbox2";width=20;           fixed_width = true; }
       }
        :row {
          :button {label="����� ����"; key="bt1";}
          :button {label="��   ��"; key="accept"; is_default=true;       }// allow_accept=true;}
          // cancel_only;
          :button {label="��   ��"; key="cancel";}
        }
} 
