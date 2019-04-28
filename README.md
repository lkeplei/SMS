# SMS
利用 sklearn 自建模型进行的一个短信拦截应用

目标：希望可以达到在iOS设备上拦截垃圾短信

目前进展：
1. 完成在30W+的训练数据集上准确率0.99+的准确率
2. 已通过coremltools将sklearn的数据模型转换为coreml可以识别的模型
3. 在iOS的项目已可以正常使用并通过模型区分短信类别
4. 短信拦截的扩展设置已完成
5. 最后一步，在收到短信时进行模型分类短信，并进行相应的过滤（目前卡在这里，扩展在初始时会内存爆掉--还不知道什么原因）

# python 模型生成代码

    import pandas as pd
    import jieba
    import coremltools
    from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer     #
    from sklearn.svm import LinearSVC
    from sklearn.model_selection import train_test_split
    
    
    # jieba 进行分词
    def jb(content):
        data = []
        for item in content:
            con = jieba.cut(item)
            con = ' '.join(list(con))
            data.append(con)
        return data
    
    
    # 保存文件
    def text_save(filename, data):
        file = open(filename, 'a')
    
        for item in data:
            print(item)
            file.write(item + '\n')

        file.close()
        print('文件保存成功')
    
    
    # 读取数据
    data = pd.read_csv('./python练习/study/example-1/data/80w.txt', sep='\t')
    data = data.drop('id', axis=1)      # 删除无用的列
    
    x_predict = data['ret']
    
    # 拆分训练集与测试集
    x_train, x_test, y_train, y_test = train_test_split(data['content'], x_predict, test_size=0.25)    # 随机采样25%的数据样本作为测试集
    
    x_train = jb(x_train)
    x_test = jb(x_test)
    
    # 文本特征提取
    cv = CountVectorizer()
    x_train = cv.fit_transform(x_train)
    x_test = cv.transform(x_test)
    
    print(cv.get_feature_names())
    
    text_save('./python练习/study/example-1/feature.txt', cv.get_feature_names())
    
    model = LinearSVC()
    model.fit(x_train, y_train)
    
    print('The Accuracy of Naive Bayes Classifier is:', model.score(x_test, y_test))
    
    # 转换成 coreml 可以识别的模型
    coreml_model = coremltools.converters.sklearn.convert(model, 'message', 'predict')
    
    coreml_model.author = "ken.liu"
    coreml_model.license = '短信拦截'
    coreml_model.short_description = '垃圾短信拦截'
    
    coreml_model.input_description['message'] = "内容"
    coreml_model.output_description['predict'] = "预计的结果"
    
    coreml_model.save('./python练习/study/example-1/PredictSMS.mlmodel')
