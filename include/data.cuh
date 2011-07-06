/* 
 * File:   data.cuh
 * Author: Alex Krizhevsky (akrizhevsky@gmail.com)
 *
 * Created on June 24, 2011, 9:09 PM
 */

#ifndef DATA_CUH
#define	DATA_CUH

#include <vector>
#include <algorithm>
#include "util.cuh"

template <class T>
class Data {
protected:
    std::vector<T*>* _data;
public:
    typedef typename std::vector<T*>::iterator T_iter;
    
    Data(std::vector<T*>& data) : _data(&data) {
        assert(_data->size() > 0);
        for (int i = 1; i < data.size(); i++) {
            assert(data[i-1]->getLeadingDim() == data[i]->getLeadingDim());
        }
        assert(data[0]->getLeadingDim() > 0);
    }

    ~Data() {
        for(T_iter it = _data->begin(); it != _data->end(); ++it) {
            delete *it;
        }
        delete _data;
    }
    
    T& operator [](int idx) {
        return *_data->at(idx);
    }
    
    int getSize() {
        return _data->size();
    }
    
    std::vector<T*>& getData() {
        return *_data;
    }

    int getNumCases() {
        return _data->at(0)->getLeadingDim();
    }
};

typedef Data<NVMatrix> GPUData;
typedef Data<Matrix> CPUData;

class DataProvider {
protected:
    CPUData* _hData;
    NVMatrixV _data;
    int _minibatchSize;
    int _dataSize;
public:
    DataProvider(int minibatchSize);
    GPUData& operator[](int idx);
    void setData(CPUData&);
    GPUData& getMinibatch(int idx);
    GPUData& getDataSlice(int startCase, int endCase);
    int getNumMinibatches();
    int getMinibatchSize();
    int getNumCases();
    int getNumCasesInMinibatch(int idx);
};

#endif	/* DATA_CUH */

