#include "skeleton.h"

int max_depth_completed;
int c_mask[64];

const int bit_table[64] = {
   0,  1,  2,  7,  3, 13,  8, 19,
   4, 25, 14, 28,  9, 34, 20, 40,
   5, 17, 26, 38, 15, 46, 29, 48,
  10, 31, 35, 54, 21, 50, 41, 57,
  63,  6, 12, 18, 24, 27, 33, 39,
  16, 37, 45, 47, 30, 53, 49, 56,
  62, 11, 23, 32, 36, 44, 52, 55,
  61, 22, 43, 51, 60, 42, 59, 58
};

const int tp_value[7] = { 100, 325, 325, 500, 1000,  0,   0 };
const int ph_value[7] = {   0,   1,   1,   2,   4,   0,   0 };

U64 zob_piece[12][64];
U64 zob_castle[16];
U64 zob_ep[8];
int move_time;
int pondering;
int search_depth;
U64 nodes;
int abort_search;
int start_time;
ENTRY *tt;
int tt_size;
int tt_mask;
int tt_date;
