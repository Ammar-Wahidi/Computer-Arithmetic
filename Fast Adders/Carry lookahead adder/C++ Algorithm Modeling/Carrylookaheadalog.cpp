#include <iostream>
#include <bitset>

using namespace std ;

bitset<16> createBitset(bool cinn, bool c1, bool c2, bool c3, bool c4, bool c5, bool c6, bool c7,
                         bool c8, bool c9, bool c10, bool c11, bool c12, bool c13, bool c14, bool c15);

//Carry Look Ahead Alogrithm
int main (){

//initialize x,y,p,g as 16 bits
bitset<16> x,y;

bitset<16> p ,g;

bool cinn =0;
int a, b;
    cin >> a >> b;  // Read decimal inputs

    x = bitset<16>(a);  // Convert to binary
    y = bitset<16>(b);  // Convert to binary

for (int i =0;i<16;i++)
{
    p[i]=x[i]^y[i];
    g[i]=x[i]&y[i];
}

//CLA0
cout <<"cla0"<<endl ;
bool c1,c2,c3;
bool gcla;
bool pcla;

gcla = g[3] | (g[2]&p[3]) |(g[1]&p[2]&p[3]) |(g[0]&p[1]&p[2]&p[3]) ;
pcla = p[0] & p[1] & p[2] & p[3] ;

//check 1
cout << "check 1"<<endl ;
cout << g << "\n" << p<<endl;
cout << gcla<<endl ;
cout << pcla<<endl ;
cout << "finish check 1"<<endl;

/*
if a = 5, b=10
    a=0101 , b=1010
    p=1111 , g=0000
    gcla = 0
    pcla = 1
    -----
    ok
*/
c1= g[0] | (p[0] & cinn) ;
c2= g[1] | (g[0]&p[1]) | (p[1]&p[0]&cinn);
c3 = g[2] | (g[1]&p[2]) | (g[0]&p[1]&p[2])|(p[0]&p[1]&p[2]&cinn);

bitset<16> s;
s[0] = cinn ^ p[0];
s[1] = c1 ^ p[1] ;
s[2] = c2 ^ p[2] ;
s[3] = c3 ^ p[3] ;

bool coutt0;
//check  2
coutt0 = (p[3] & c3) | g[3]  ; //wrong for design but logical right
s[4] = coutt0;
cout << "check 2 (try sum 4 bits)"<<endl ;
cout << s << "\n" << coutt0 <<endl ;
cout << "finish check 2"<<endl;

//CLA1
bool c5,c6,c7 ;
bool gcla1,pcla1;

gcla1 = g[7] | (g[6]&p[7]) |(g[5]&p[6]&p[7]) |(g[4]&p[5]&p[6]&p[7]) ;
pcla1 = p[4] & p[5] & p[6] & p[7] ;

//CLA2
bool c9,c10,c11 ;
bool gcla2,pcla2;

gcla2 = g[11] | (g[10]&p[11]) |(g[9]&p[10]&p[11]) |(g[8]&p[9]&p[10]&p[11]) ;
pcla2 = p[8] & p[9] & p[10] & p[11] ;

//CLA3
bool c13,c14,c15 ;
bool gcla3,pcla3;

gcla2 = g[15] | (g[14]&p[15]) |(g[13]&p[14]&p[15]) |(g[12]&p[13]&p[14]&p[15]) ;
pcla2 = p[12] & p[13] & p[14] & p[15] ;

//CLA4
bool c4,c8,c12 ;
bool gcla4,pcla4;

gcla4 = gcla3 | (gcla2&pcla3) |(gcla1&pcla2&pcla3) |(gcla&pcla1&pcla2&pcla3) ;
pcla4 = pcla & pcla1 & pcla2 & pcla3 ;

//calculate c4,c8,c12
c4= gcla | (pcla & cinn) ;
c8= gcla1 | (gcla&pcla1) | (pcla1&pcla&cinn);
c12 = gcla2 | (gcla1&pcla2) | (gcla&pcla1&pcla2)|(pcla&pcla1&pcla2&cinn);

//calculate other c
c5= g[4] | (p[4] & c4) ;
c6= g[5] | (g[4]&p[5]) | (p[5]&p[4]&c4);
c7 = g[6] | (g[5]&p[6]) | (g[4]&p[5]&p[6])|(p[4]&p[5]&p[6]&c4);

c9= g[8] | (p[8] & c8) ;
c10= g[9] | (g[8]&p[9]) | (p[9]&p[8]&c8);
c11 = g[10] | (g[9]&p[10]) | (g[8]&p[9]&p[10])|(p[8]&p[9]&p[10]&c8);

c13= g[12] | (p[12] & c12) ;
c14= g[13] | (g[12]&p[13]) | (p[13]&p[12]&c12);
c15= g[14] | (g[13]&p[14]) | (g[12]&p[13]&p[14])|(p[12]&p[13]&p[14]&c12);

//sum
bitset<16> c = createBitset(cinn,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15) ;
bool coutt = gcla3 | gcla  ;

for (int i=0;i<16;i++)
{
    s[i]=c[i]^p[i] ;
}

cout << "sum 16 bits =" << s << endl;
return 0;
}

bitset<16> createBitset(bool c0, bool c1, bool c2, bool c3, bool c4, bool c5, bool c6, bool c7,
                         bool c8, bool c9, bool c10, bool c11, bool c12, bool c13, bool c14, bool c15) {
    bitset<16> c;
    bool carryBits[16] = {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15};


    for (int i = 0; i < 16; i++) {
        c[i] = carryBits[i];
    }

    return c;
}
