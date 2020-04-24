#include <cuda_runtime.h>
#include <cuda.h>


#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <iostream>
#include <iterator>
#include <vector>

using std::begin;
using std::copy;
using std::cout;
using std::endl;
using std::end;
using std::generate;
using std::vector;


__global__ void add(int* out, int* a, int* b, int n) {
    out[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
    /* for (int i = 0; i < 10; i++) {
        out[i] = a[i] + b[i];
    }*/
}


int main() {
    int* a, * b, * out;
    int N = 100;
    int size = sizeof(int) * N;
    a = (int*)malloc(size);
    b = (int*)malloc(size);
    out = (int*)malloc(size);
    for (int i = 0; i < N; i++) {
        a[i] = i;
        b[i] = N;
        out[i] = 0;
    }

    int* d_a, * d_b, * d_out;
    cudaMalloc(&d_a, size);
    cudaMalloc(&d_b, size);
    cudaMalloc(&d_out, size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    cudaMemcpy(d_out, out, size, cudaMemcpyHostToDevice);
    cout << " COMPLETED SUCCESSFULLY\n";

    // blocks, threads per block. 1024 threads per block
    // add <<<N/256 + 1, 256>>
    add << <N, 1>> > (d_out, d_a, d_b, N);
    cudaMemcpy(out, d_out, size, cudaMemcpyDeviceToHost);
    // not &out
    
    for (int i = 0; i < N; i++) {
        cout << out[i] << endl;
    }
    cout << " COMPLETED SUCCESSFULLY\n";

    //    //// Cleanup after kernel execution
    cudaFree(d_a);    cudaFree(d_b);    cudaFree(d_out);
    free(a);    free(b);
    return 0;

}
