#include <stdio.h>

#ifdef _MSC_VER
#define DLL_EXPORT __declspec( dllexport ) 
#else
#define DLL_EXPORT
#endif

DLL_EXPORT void cfun(const void * indatav, int rowcount, int colcount, void * outdatav)
{
	//void cfun(const double * indata, int rowcount, int colcount, double * outdata) {
	const double * indata = (double *)indatav;
	double * outdata = (double *)outdatav;
	int i;
	puts("Here we go!");
	for (i = 0; i < rowcount * colcount; ++i) {
		outdata[i] = indata[i] * 2;
	}
	puts("Done!");
}




