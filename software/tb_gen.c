#include <stdio.h>
#include <stdlib.h>


/*****************************************************************************/
/* Defines:                                                                  */
/*****************************************************************************/
// The number of columns comprising a state in AES. This is a constant in AES. Value=4
#define Nb 4
// The number of 32 bit words in a key.
#define Nk 4
// Key length in bytes [128 bit]
#define KEYLEN 16
// The number of rounds in AES Cipher.
#define Nr 10 // 10, 12 or 14 (depending on key size)


unsigned char Rcon[255] = {
  0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 
  0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 
  0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 
  0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 
  0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 
  0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 
  0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 
  0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 
  0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 
  0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 
  0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 
  0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 
  0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 
  0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 
  0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 
  0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb  };


unsigned char sbox[256] =   {
  //0     1    2      3     4    5     6     7      8    9     A      B    C     D     E     F
  0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
  0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
  0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
  0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
  0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
  0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
  0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
  0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
  0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
  0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
  0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
  0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
  0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
  0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
  0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
  0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 };


// The array that stores the round keys.
unsigned char RoundKey[176];

// The Key input to the AES Program
unsigned char Key[Nk*4];


unsigned char  getSBoxValue(unsigned char num)
{
  return sbox[num];
}

static void KeyExpansion(void)
{
  unsigned int i, j, k,p;
  unsigned char tempa[4]; // Used for the column/row operations
  printf("#---------------\n");
  printf("#--KeyExpansion\n");
  printf("#---------------\n");
  //printf("Nk = %d , Nb = %d , Nr = %d\n",Nk,Nb,Nr);
  
  // The first round key is the key itself.
  for(i = 0; i < Nk; ++i)
  {
    RoundKey[(i * 4) + 0] = Key[(i * 4) + 0];
    RoundKey[(i * 4) + 1] = Key[(i * 4) + 1];
    RoundKey[(i * 4) + 2] = Key[(i * 4) + 2];
    RoundKey[(i * 4) + 3] = Key[(i * 4) + 3];

    printf("RoundKey[%d] = %d\n",(i * 4) + 0 , Key[(i * 4) + 0]);
    printf("RoundKey[%d] = %d\n",(i * 4) + 1 , Key[(i * 4) + 1]);
    printf("RoundKey[%d] = %d\n",(i * 4) + 2 , Key[(i * 4) + 2]);
    printf("RoundKey[%d] = %d\n",(i * 4) + 3 , Key[(i * 4) + 3]);
  }
  p = 0;

  // All other round keys are found from the previous round keys.
  for(; (i < (Nb * (Nr + 1))); ++i) //4 * 14 = 
  {
     if (i % Nk == 0)
        printf("%d----------------------------------#\n",p++);

    for(j = 0; j < 4; ++j)
    {
      tempa[j]=RoundKey[(i-1) * 4 + j];
     printf("tempa[%d]=RoundKey[%d]; (%d/%d) = %d\n" , j , (i-1) * 4 + j,i,Nk ,(i/Nk));
    }
  //printf("%d  %% %d = %d\n",i,Nk,(i % Nk) );
    if (i % Nk == 0)
    {
    //printf(".\n");
      // This function rotates the 4 bytes in a word to the left once.
      // [a0,a1,a2,a3] becomes [a1,a2,a3,a0]

      // Function RotWord()
      {
        k = tempa[0];
        tempa[0] = tempa[1];
        tempa[1] = tempa[2];
        tempa[2] = tempa[3];
        tempa[3] = k;
      }

      // SubWord() is a function that takes a four-byte input word and 
      // applies the S-box to each of the four bytes to produce an output word.

      // Function Subword()
      {
        tempa[0] = getSBoxValue(tempa[0]);
        tempa[1] = getSBoxValue(tempa[1]);
        tempa[2] = getSBoxValue(tempa[2]);
        tempa[3] = getSBoxValue(tempa[3]);
      }

      tempa[0] =  tempa[0] ^ Rcon[i/Nk];
      printf("Rcon[i/Nk] = %02x\n",Rcon[i/Nk]);
    }
    else if (Nk > 6 && i % Nk == 4)
    {
      // Function Subword()
      {
        tempa[0] = getSBoxValue(tempa[0]);
        tempa[1] = getSBoxValue(tempa[1]);
        tempa[2] = getSBoxValue(tempa[2]);
        tempa[3] = getSBoxValue(tempa[3]);
      }
    } else {
    
    
  }

  printf("RoundKey[(i - Nk) * 4 + 0] = %02x\n" , RoundKey[(i - Nk) * 4 + 0]);
    printf("tempa[0] = %02x\n" , tempa[0]); 

     printf("RoundKey[(i - Nk) * 4 + 1] = %02x\n" , RoundKey[(i - Nk) * 4 + 1]);
    printf("tempa[1] = %02x\n" , tempa[1]); 

     printf("RoundKey[(i - Nk) * 4 + 2] = %02x\n" , RoundKey[(i - Nk) * 4 + 2]);
    printf("tempa[2] = %02x\n" , tempa[2]); 

     printf("RoundKey[(i - Nk) * 4 + 3] = %02x\n" , RoundKey[(i - Nk) * 4 + 3]);
    printf("tempa[3] = %02x\n" , tempa[3]); 
    RoundKey[i * 4 + 0] = RoundKey[(i - Nk) * 4 + 0] ^ tempa[0];
    RoundKey[i * 4 + 1] = RoundKey[(i - Nk) * 4 + 1] ^ tempa[1];
    RoundKey[i * 4 + 2] = RoundKey[(i - Nk) * 4 + 2] ^ tempa[2];
    RoundKey[i * 4 + 3] = RoundKey[(i - Nk) * 4 + 3] ^ tempa[3];
     printf( "RoundKey[%d] = RoundKey[%d] ^ tempa[0] = %d\n",i * 4 + 0,(i - Nk) * 4 + 0, RoundKey[i * 4 + 0]);
  printf( "RoundKey[%d] = RoundKey[%d] ^ tempa[1] = %d\n",i * 4 + 1,(i - Nk) * 4 + 1, RoundKey[i * 4 + 1]);
  printf( "RoundKey[%d] = RoundKey[%d] ^ tempa[2] = %d\n",i * 4 + 2,(i - Nk) * 4 + 2, RoundKey[i * 4 + 2]);
  printf( "RoundKey[%d] = RoundKey[%d] ^ tempa[3] = %d\n",i * 4 + 3,(i - Nk) * 4 + 3, RoundKey[i * 4 + 3]);
  
  }
}


int main (void){
  FILE *fp_out;
  int i;
  int *tb_int_pointer;


  if ((fp_out = fopen("Rcon.init","w")) == NULL) {
    printf("Error opening file %s for writing\n", "Rcon.init");
    return -1;
  }

  for(i = 0; i<256; i++){
    fprintf(fp_out, "%02x\n", Rcon[i]);
  }
  fclose(fp_out);

  if ((fp_out = fopen("sbox.init","w")) == NULL) {
    printf("Error opening file %s for writing\n", "sbox.init");
    return -1;
  }  

  for(i = 0; i<256; i++){
    fprintf(fp_out, "%02x\n", sbox[i]);
  }
  fclose(fp_out);

  if ((fp_out = fopen("key_in.tb","w")) == NULL) {
    printf("Error opening file %s for writing\n", "key_in.tb");
    return -1;
  }

  for(i = 0 ; i < Nk*4 ; i++){
    Key[i] = (char)i;
  }

  /*tb_int_pointer = (int *) Key;
  for(i = 0; i < Nk ; i++){
    fprintf(fp_out, "%08x\n", tb_int_pointer[i]);
  }
  fclose(fp_out);
  */
  for(i = 0; i < Nk * 4 ; i=i+4){
    fprintf(fp_out, "%02x%02x%02x%02x\n", Key[i],Key[i+1],Key[i+2],Key[i+3]);
  }


  KeyExpansion(); 


  if ((fp_out = fopen("key_out.tb","w")) == NULL) {
    printf("Error opening file %s for writing\n", "key_out.tb");
    return -1;
  }

  /*tb_int_pointer = (int *) RoundKey;
  for(i = 0; i < (Nb * (Nr + 1)) ; i++){
    fprintf(fp_out, "%08x\n", tb_int_pointer[i]);
  }
*/

  for(i = 0; i < (Nb * (Nr + 1)) * 4 ; i=i+4){
    fprintf(fp_out, "%02x%02x%02x%02x\n", RoundKey[i],RoundKey[i+1],RoundKey[i+2],RoundKey[i+3]);
  }

  fclose(fp_out);

  return 0;
}