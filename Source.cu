

#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// includes CUDA
#include "cuda.h"
#include <cuda_runtime.h>
#include "device_launch_parameters.h"

// nvcc does not seem to like variadic macros, so we have to define
// one for each kernel parameter list:
#ifdef __CUDACC__
#define KERNEL_ARGS2(grid, block) <<< grid, block >>>
#define KERNEL_ARGS3(grid, block, sh_mem) <<< grid, block, sh_mem >>>
#define KERNEL_ARGS4(grid, block, sh_mem, stream) <<< grid, block, sh_mem, stream >>>
#else
#define KERNEL_ARGS2(grid, block)
#define KERNEL_ARGS3(grid, block, sh_mem)
#define KERNEL_ARGS4(grid, block, sh_mem, stream)
#endif

//���ޥΨ쪺���c��
struct Index {
	int block, thread;
};


//�֤�:����޼g�J�˸m�O����
__global__ void prob_idx(Index id[])
{
	int b = blockIdx.x;       //�϶�����
	int t = threadIdx.x;      //���������
	int n = blockDim.x;       //�϶����]�t��������ƥ�
	int x = b*n + t;            //������b�}�C����������m

								//�C�Ӱ�����g�J�ۤv���϶��M���������.
	id[x].block = b;
	id[x].thread = t;
};

//�D�禡
int main() {
	Index* d;
	Index  h[100];

	//�t�m�˸m�O����
	cudaMalloc((void**)&d, 100 * sizeof(Index));

	//�I�s�˸m�֤�
	int g = 3, b = 4, m = g*b;
	// prob_idx<<< g, b>>>(d);

	prob_idx KERNEL_ARGS2(dim3(nBlockCount), dim3(nThreadCount)) (d);

	//�U���˸m�O���餺�e��D���W
	cudaMemcpy(h, d, 100 * sizeof(Index), cudaMemcpyDeviceToHost);

	//��ܤ��e
	for (int i = 0; i<m; i++) {
		printf("h[%d]={block:%d, thread:%d}\n", i, h[i].block, h[i].thread);
	}

	//����˸m�O����
	cudaFree(d);
	return 0;
}