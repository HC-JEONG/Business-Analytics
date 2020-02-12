# 매트릭스 실습
# nrow : 2행 나누기 
m1<-matrix(c('a','b','c','d'),nrow=2)
# ncol : 2열 나누기 
m2<-matrix(c('a','b','c','d'),ncol=2)
# nrow : 3행 나누기
m3<-matrix(c('a','b','c','d','e','f'),nrow=3)
# ncol : 3열 나누기 
m4<-matrix(c('a','b','c','d','e','f'),ncol=3)

# m4 변수 1행 1열 출력
m4[1,1]
# m4 변수 2행 3열 출력
m4[2,3]
# m3 변수 1행 전체 출력
m3[1,]
# m3 변수 1열 전체 출력
m3[,1]

# RData 저장 및 로드
save(m1,m2,m3,m4, file="mydata.RData")
load("mydata.RData")
