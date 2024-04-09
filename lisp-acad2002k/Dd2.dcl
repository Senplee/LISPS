text_ch : dialog {
    label = "Text Change";
    initial_focus = "ed_text";
    : edit_box {
        label = "Text:";
        key   = "ed_text";
        edit_width = 40;
        edit_limit = 255;
        allow_accept = true;
    }
    : row {
        spacer;
        : button {
            label = "Pick text <";
            key   = "pt_text";
            width = 10;
        }
        ok_cancel;
    }
}
