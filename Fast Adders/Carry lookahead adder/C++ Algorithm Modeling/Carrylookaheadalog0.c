#include <iostream>
#include <bitset>

using namespace std ;

int main (){

bitset<15> x,y;

bitset<15> p ,g;


for (int i =0;i<16;i++)
{
    p[i]=x^y;
    g=x&y;
}


}
