#include<iostream>
#include <bitset>
using namespace std ;

int64_t bitsetToInt64(bitset<64> b);

int main()
{
    //Multiplier HW support for Signed Alogrithm

bitset<32> Multiplier , Multiplicand ;
int mr,md;
cout << "Multiplier: "<<"\n" ;
cin >>mr;
cout << "Multiplicand: "<<"\n" ;
cin >>md;

    Multiplier = bitset<32>(mr);  // Convert to binary
    Multiplicand = bitset<32>(md);  // Convert to binary

bitset<64> Partial_product  ;
for (int i = 0; i < 32; i++) {
        Partial_product[i] = Multiplier[i];
    }

    cout << "Multiplier: "<< Multiplier<<"\n"<< "Multiplicand: "<< Multiplicand<<"\n"<< "Partial_product: "<< Partial_product<<"\n" ;

for (int i=0;i<32;i++ )
{
    //enable and select
    bool enable = Partial_product[0];
    bool select= (i ==31) ? 1:0;

        //capture first 32 bits
        bitset<32> upperBits;
for (int j = 0; j < 32; j++) {
    upperBits[j] = Partial_product[j + 32];
}

        //Multiplicand+upperBits
        bool cinn = select ;
        bool coutt;
        bitset<32> sum;
        if(select)
        {
            Multiplicand=~Multiplicand;
        }
        for (int j=0;j<32;j++)
        {
            if (enable)
            {
            sum[j]=Multiplicand[j]^upperBits[j]^cinn ;
            cinn = ((Multiplicand[j]^upperBits[j]) & cinn) | (Multiplicand[j]&upperBits[j]);
            }
            else if(!enable & !select)
            {
            sum[j]=upperBits[j]^cinn ;
            cinn = ((0^upperBits[j]) & cinn) | (0&upperBits[j]);
            }
            else if (!enable & select)
            {
                cinn=0;
            sum[j]=0^upperBits[j]^cinn ;
            cinn = ((0^upperBits[j]) & cinn) | (0&upperBits[j]);
            }

        }
        coutt = cinn ;

        //adjust new 32 bit
        for (int j = 0; j < 32; j++) {
    Partial_product[j + 32]= sum[j];

}

//right shift
Partial_product=Partial_product>>1 ;
Partial_product[63]=Partial_product[62];
/*if (coutt==1)
    Partial_product[63] =1 ;
*/

}

//check
cout << "Partial product:" << Partial_product << "\n   NUM="<< bitsetToInt64(Partial_product) ;
return 0;
}

//function
int64_t bitsetToInt64(bitset<64> b) {
    if (b[63] == 1) { // If MSB is 1, it's negative (two's complement)
        return static_cast<int64_t>(b.to_ullong()) - (1LL << 64);
    } else {
        return static_cast<int64_t>(b.to_ullong());
    }
}
