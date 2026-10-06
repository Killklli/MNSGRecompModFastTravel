// Allows the player to press the start button to skip the dragon animation.
#include "common.h"
#include "modding.h"
#include "ultra64.h"

// External function declarations
extern s32 func_80210F80_66FF30(void *entity_data);
extern void func_802111C4_670174(void *data_ptr);
extern void func_8003521C_35E1C(void (*callback_func)());
extern void func_802112C0_670270(void);
extern SYS_W D_8008CCC0_8D8C0;

RECOMP_PATCH void func_802113C8_670378(void *entity, s32 arg1) {
    void *entity_data;
    void *data_ptr;
    s32 result;
    entity_data = *(void **)((char *)entity + 0x68);
    // Check if the animation is complete
    result = func_80210F80_66FF30(entity_data);
    if ((D_8008CCC0_8D8C0.controller[0].button_held_down & START_BUTTON)) {
        // Early exit the animation
        result = 1;
    }
    if (result == 1) {
        data_ptr = (char *)entity + 0x5C;
        func_802111C4_670174(*(void **)((char *)data_ptr + 0x8));
        *(void **)((char *)data_ptr + 0x18) = NULL;
        func_8003521C_35E1C(func_802112C0_670270);
    }
}