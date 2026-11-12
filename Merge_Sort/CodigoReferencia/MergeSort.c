#include <stdio.h>
#include <stdlib.h>

void merge(int arr[], int aux[], int begin, int mid, int end) {
    int i = begin;      
    int j = mid + 1;    
    int k = begin;

    while (i <= mid && j <= end) {
        if (arr[i] <= arr[j]) {
            aux[k++] = arr[i++];
        } else {
            aux[k++] = arr[j++];
        }
    }

    while (i <= mid) {
        aux[k++] = arr[i++];
    }

    while (j <= end) {
        aux[k++] = arr[j++];
    }

    for (i = begin; i <= end; i++) {
        arr[i] = aux[i];
    }
}

void merge_sort(int *array, int *aux, int begin, int end){
    if(begin < end){
        int mid = begin + (end - begin)/2;

        merge_sort(array, aux, begin, mid);
        merge_sort(array, aux, mid+1, end);
        merge(array, aux, begin, mid, end);
    }
}

void display_array(int *array, int n){
    for(int i=0;i<n;i++){
        printf("%d ", array[i]);
    }
    printf("\n");
}

int main()
{
    int array[] = {4, 2, 1, 7, 8, 5, 3, 9, 10, 6};
    int n = sizeof(array)/sizeof(int);
    int *aux = (int*) malloc(n*sizeof(int));

    display_array(array, n);
    merge_sort(array, aux, 0, n-1);
    display_array(array, n);
    free(aux);

    return 0;
}
