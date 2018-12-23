# -*- coding: utf-8 -*-
import scrapy
import re
from numpy import genfromtxt
from numpy import delete
from numpy import nditer

class InfomoneySpider(scrapy.Spider):
    name = 'infomoney'
    allowed_domains = ['infomoney.com.br']

    def start_requests(self):
        my_data = genfromtxt('interval8.csv', delimiter=',')
        my_data = delete(my_data, 0)
        for index in nditer(my_data):
            url = "https://www.infomoney.com.br/mercados/noticia/" + str(int(index))
            yield scrapy.Request(url, callback=self.parse)

    def parse(self, response):
        self.logger.info('A response from %s just arrived!', response.url)

        index = int(re.search(r'\d+', response.request.url).group())
        date = response.css('.article__date::text').extract()
        title = response.css('.article__title::text').extract()

        yield {'date': date, 'title':title, 'index':index}
