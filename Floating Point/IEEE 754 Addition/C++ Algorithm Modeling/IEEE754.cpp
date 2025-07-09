#include <iostream>
#include <bitset>
#include <vector>
#include <algorithm>

using namespace std;

int main ()
{
    int t=0;
    while (t<=3)
    {
    //integer part and fraction part
    float x ;
    cin >> x ;
    int xi;
    float x_frac;
    bool sign ;
    if (x>=0)
    {
        sign =0;
    }
    else
    {
        sign =1;
        x=-x;
    }

    xi=x;
    x_frac = x-xi;
    cout << "integer part: " << xi << "\nfrac part:"<< x_frac <<endl;

    //convert integer part to binary base
    vector <int> xbinary ;
    int res =xi ;
    float res_f;
    while(res!=0 )
    {
        res_f=res/2.0;
        res=res/2;
        if (res_f - res == 0 )
        {
            xbinary.push_back(0);
        }
        else
        {
            xbinary.push_back(1);
            res_f = res;
        }
    }

   reverse(xbinary.begin(), xbinary.end());

    cout <<"intger part binary base: ";
for (int i =0;i<xbinary.size();i++)
{
    cout <<xbinary[i];
}

vector <int> xfracbinary ;
res_f = x_frac;
int m=0;
while (res_f!=0)
{
    res_f = res_f * 2.0;
    if (res_f <1 )
    {
        xfracbinary.push_back(0);
    }
    else
    {
        xfracbinary.push_back(1);
        res_f =res_f -1.0;
    }

    if (xfracbinary.size () > 25)
        break ;
}
cout <<"\nfrac part binary base: ";
for (int i =0;i<xfracbinary.size();i++)
{
    cout <<xfracbinary[i];
}

bitset <8> expo8;
bitset <23> frac23;
bitset <32> IEEE754;
if (xbinary.size() !=0)
{
int sizexpo8 = xbinary.size()-1;
sizexpo8 = 127 + sizexpo8;
expo8 = bitset<8>(sizexpo8);
int k=0;
    for (int j=22;j>23-xbinary.size();j--)
    {
        frac23[j] = xbinary[k+1];
        k++;
    }
    k=0;
    for (int j=(23-xbinary.size());j>=0;j--)
    {
        if (k <xfracbinary.size() )
        {
        frac23[j] = xfracbinary[k];
        k++;
        }
    }
k=0;
   for (int j = 31; j >=0; j--) {
        if (j == 31)
            IEEE754[j] = sign;
        else if (j >= 23)
        {
            IEEE754[j] = expo8[7-k];
            k++;
            if(j==23)
            {
                k=0;
            }
        }
        else
        {
            IEEE754[j] = frac23[22-k];
            k++;
        }
    }

    cout << "\n"<< sign  << "\n" <<expo8 << "\n" << frac23 << "\nIEEE745 Standard =" <<IEEE754;
}
else
{
    int sizexpo8;

    for (int i=0;i<xfracbinary.size();i++)
    {
        if (xfracbinary[i]==1)
        {
            sizexpo8 = i+1;
            break ;
        }
    }
sizexpo8 = 127 - sizexpo8;
expo8 = bitset<8>(sizexpo8);
    int k=0;
    for (int j=(23-xbinary.size());j>=0;j--)
    {
        if (k <xfracbinary.size() )
        {
        frac23[j] = xfracbinary[k];
        k++;
        }
    }
k=0;
   for (int j = 31; j >=0; j--) {
        if (j == 31)
            IEEE754[j] = sign;
        else if (j >= 23)
        {
            IEEE754[j] = expo8[7-k];
            k++;
            if(j==23)
            {
                k=0;
            }
        }
        else
        {
            IEEE754[j] = frac23[22-k];
            k++;
        }
    }

    cout << "\n"<< sign  << "\n" <<expo8 << "\n" << frac23 << "\nIEEE745 Standard =" <<IEEE754;
}

cout << "\nNew number \n";
    }

}
