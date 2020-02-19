##########################################
rm(list = ls()) # object remove 
##########################################


##########################################################
########## step.1 preparing the data (문제 1,2,3) ########
##########################################################
# 문제 1-1
# working directory 설정
setwd('C:/BBA')
getwd()

# 데이터 불러오기
credit<-read.csv('credittw.csv')
credit$default <- factor(credit$default, levels=c(0,1), labels=c(0,1))


# 문제 1-2
View(credit)

# 문제 2
credit_rand<-credit[-c(1,3,4,5,13,14,15,16,17,18,25)]
str(credit_rand)

# 문제 3
# data split
# 3-1
credit_train<-credit_rand[1:6000,]
credit_test<-credit_rand[6001:10000,]

# 3-2
credit_train_labels<-credit[1:6000,25]
credit_test_labels<-credit[6001:10000,25]

##########################################################
###### Step.2 Training a model on the data (문제 4) ######
##########################################################
library(class)
credit_test_pred <- knn(train = credit_train, test = credit_test, cl = credit_train_labels, k=17)


##########################################################
### Step.3  Evaluating model performance (문제 5) ########
##########################################################
library(gmodels)
CrossTable(x = credit_test_labels, y = credit_test_pred,
           prop.chisq=FALSE)



##########################################################
### Step.4 Other K-value experiments  (문제 6) ###########
##########################################################

# k=15
credit_test_pred_15 <- knn(train = credit_train, test = credit_test, cl = credit_train_labels, k=15)
CrossTable(x = credit_test_labels, y = credit_test_pred_15,
           prop.chisq=FALSE)
# k=19
credit_test_pred_19 <- knn(train = credit_train, test = credit_test, cl = credit_train_labels, k=19)
CrossTable(x = credit_test_labels, y = credit_test_pred_19,
           prop.chisq=FALSE)
# k=21
credit_test_pred_21 <- knn(train = credit_train, test = credit_test, cl = credit_train_labels, k=21)
CrossTable(x = credit_test_labels, y = credit_test_pred_21,
           prop.chisq=FALSE)

##########################################################
#################### 보너스  #############################
##########################################################
# 기존 credit 변수에서 ID, BILL_AMT1~AMT6을 제거하고 종속변수인 default를 없앤 변수를 credit2로 저장
credit2<-credit[-c(1,13:18,25)]
str(credit2)
# SEX, EDUCATION, MARRIAGE, PAY_1~6 팩터화
credit2[,c(2,3,4,6:11)]<-lapply(credit2[,c(2,3,4,6:11)],factor)
str(credit2)
# AGE를 3 범주로 나눔
credit2$AGE_CLASS<-cut(credit2$AGE,3,c(1,2,3))

# MAXMINSCALE 함수 정의
normalize<-function(x){
  return((x-min(x))/(max(x)-min(x)))
}
# LIMIT_BAL, AGE, PAY_AMT1~6 normalization
credit2[,c(1,5,12:17)]<-lapply(credit2[,c(1,5,12:17)],normalize)
str(credit2)
# 세 범주로 나눈 AGE_CLASS를 추가했으므로 AGE 변수 제거
credit2<-credit2[,-5]
str(credit2)

# 데이터 분할
credit2_train<-credit2[1:6000,]
credit2_test<-credit2[6001:10000,]

# 정확도 저장할 벡터 생성
accuracy<-c(1:10)

# 9~27 사이의 홀수를 모두  k-NN에 적용해서 각각의 accuracy 구하기
for (i in 5:14) {
credit2_test_pred <- knn(train = credit2_train, test = credit2_test, cl = credit_train_labels, k=2*i-1)
knntable<-table(credit2_test_pred,credit_test_labels)
accuracy[i-4]<-((knntable[1,1]+knntable[2,2])/sum(knntable))*100
print(2*i-1)
print(accuracy[i-4])
}

# k=15일 때 정확도 가장 높음 (적중률에 대한 기준을 accuracy로 정함)
credit2_test_pred <- knn(train = credit2_train, test = credit2_test, cl = credit_train_labels, k=15)

# k=15일 때 CrossTable
CrossTable(x = credit_test_labels, y = credit2_test_pred,
           prop.chisq=FALSE)
