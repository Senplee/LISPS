jinbox_plot :dialog  {
	label="Plot-Drawing at Custmize Box";
	:row {
		:column {
			:boxed_column {
				label="�����ġ ����";
				:popup_list {
					label="���������:";
					value="0";
					key="jplot1";
					list="JIN14 \nPLOT \nPlotter \n \n \n \n \n \n \n \nA3";
//							0		1			2			3	4	5	6	7	8	9	10
				}
				:popup_list {
					label="����������:";
					value="0";
					key="jplot2";
					list="A3 \nA4 \nA1-���� \nA1-���� \n \n \n";
				}
				:popup_list {
					label="����������:";
					value="0";
					key="jplot11";
					list="��� \nĮ�� \n \n \n \n \n";
				}
			}
			:boxed_row {
				label="�����ô ����";
				:column {
					:radio_button {
						label="������ô:";
						key="jplot3";
					}
					:radio_button {
						label="������ô*2:";
						key="jplot4";
					}
					:radio_button {
						label="��ô����:";
						key="jplot5";
					}
				}
				:column {
					:edit_box {
//			         label="������ô:";
						key="jplot3a";
						value=1.0;
						width=7;
					}
					:text {
						label="1 : 1";
						key="jplot4a";
					}
					:text {
						label=" = Fit ";
						key="jplot5a";
					}
				}
			}
		}
		:boxed_row {
			label="��¹��� ����";
			:column {
				:radio_button {
					label="���� ����(W)";
					key="jplot6a";
					value=1;
				}
				:radio_button {
					label="����Ʈ ��(L)";
					key="jplot7a";
					value=0;
				}
				:radio_button {
					label="���̴´��(V)";
					key="jplot8a";
					value=0;
				}
				:radio_button {
					label="���� ��ü(E)";
					key="jplot9a";
					value=0;
				}
				:spacer { width=1; }
				:spacer { width=1; }
			}
//			:column {
//				:button {
//					label="���� ����";
//					key="jplot6";
//				}
//				:button {
//					label="����Ʈ ��";
//					key="jplot7";
//				}
//				:button {
//					label="���̴´��";
//					key="jplot8";
//				}
//				:button {
//					label="���� ��ü";
//					key="jplot9";
//				}
//				:spacer { width=1; }
////				:spacer { width=1; }
////				:spacer { width=1; }
////				:spacer { width=1; }
//			}
		}
	}
	:spacer { width=1; }
	:spacer { width=1; }
	:boxed_row {
		label="�̸�����";
//		:toggle {
//			key="jplot10a";
//		}
		:button {
			label="�̸������ �ٷν�����";
			key="jplot10";
			value=0;
		}
	}
	ok_cancel;
}
