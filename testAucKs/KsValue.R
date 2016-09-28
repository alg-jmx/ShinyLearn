KsValue = function(data,n){
  # Compute the ks value of a model
  # 
  # Args:
  #   data: A dataFrame[prediction,label] that the prediction of a model and real label
  #   n: The group number 
  # 
  # Returns:
  #   A vector that the difference value between the rate cumulative bad sample and the rate of cumulative good sample 
  dataResult = dplyr::arrange(data,desc(prediction))$label  # select label after ordering by prediction 
  a = c()  # compute the number of 1 in each group
  b = c()  # compute the number of 0 in each group
  c = c()  # 差值为累积坏样本数占比减去累计好样本数占比
  a[1] = 0
  b[1] = 0
  c[1] = 0
  if(length(dataResult)%%n==0){
    cut = length(dataResult)/n
    for (i in 2:(n+1)) {
      a[i] = sum(dataResult[(cut*(i-2)+1):(cut*(i-1))])
      b[i] = length(dataResult[(cut*(i-2)+1):(cut*(i-1))])-a[i]
    }
  }else{
    cut = round(length(dataResult)/n)
    for (i in 2:n) {
      a[i] = sum(dataResult[(cut*(i-2)+1):(cut*(i-1))])
      b[i] = length(dataResult[(cut*(i-2)+1):(cut*(i-1))])-a[i]
    }
    a[n+1] = sum(dataResult[(cut*(n-2)+1):(cut*(n-1))])
    b[n+1] = length(dataResult[(cut*(n-2)+1):(cut*(n-1))])-a[n+1]
  }
  # c = abs(cumsum(a)/sum(a)-cumsum(b)/sum(b))
  return(data.frame(cumsum(a)/sum(a),cumsum(b)/sum(b)))
}