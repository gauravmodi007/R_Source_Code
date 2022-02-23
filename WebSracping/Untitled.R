library("jsonlite")

listtest = list(
  prod1 = list(section_id = NULL, name = 'name1', slug = 'slug1'),
  prod2 = list(section_id = NULL, name = 'name2', slug = 'slug2'),
  prod3 = list(section_id = NULL, name = 'name3', slug = 'slug3', categories = 
           list(
           list(section_id = NULL, name = 'name31', slug = 'slug31'),
           list(section_id = NULL, name = 'name32', slug = 'slug32')
         )
  )
)

str(listtest)
length(listtest)

class(listtest[1])

for(i in 1:length(listtest)){
  print(i)
  finallist <- append(mylist, listtest[i])
}
finallist

write_json(finallist,"temp.json")

jsontest = jsonlite::toJSON(listtest, pretty = TRUE, auto_unbox = TRUE)

class(jsontest)

list1 <- data$details$selected
list2 <- data$details$data

mylist=c()

finallist <- append(mylist, list2)

dim(finallist)

jsontest[1]
jsontest <- gsub(pattern = '^\[', replacement = "", x = jsontest)
jsontest <- gsub(pattern = '\]$', replacement = "", x = jsontest)



