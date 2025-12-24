#include QMK_KEYBOARD_H

// Custom keycodes
enum custom_keycodes {
    MACRO1 = SAFE_RANGE,
    MACRO2,
    MACRO3,
    MACRO4,
    MACRO5,
    MACRO6,
    MACRO7,
    MACRO8,
    MACRO9
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT_ortho_3x3(
        MACRO1, MACRO2, MACRO3,
        MACRO4, MACRO5, MACRO6,
        MACRO7, MACRO8, MACRO9
    )
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case MACRO1: // Key 1
            if (record->event.pressed) {
                SEND_STRING("1");
            }
            break;
        case MACRO2: // Key 2
            if (record->event.pressed) {
                SEND_STRING("2");
            }
            break;
        case MACRO3: // Key 3
            if (record->event.pressed) {
                SEND_STRING("3");
            }
            break;
        case MACRO4: // Key 4
            if (record->event.pressed) {
                SEND_STRING("4");
            }
            break;
        case MACRO5: // Key 5
            if (record->event.pressed) {
                SEND_STRING("5");
            }
            break;
        case MACRO6: // Key 6
            if (record->event.pressed) {
                SEND_STRING("6");
            }
            break;
        case MACRO7: // Key 7
            if (record->event.pressed) {
                SEND_STRING("7");
            }
            break;
        case MACRO8: // Key 8
            if (record->event.pressed) {
                SEND_STRING("8");
            }
            break;
        case MACRO9: // Key 9
            if (record->event.pressed) {
                SEND_STRING("9");
            }
            break;
    }
    return true;
}