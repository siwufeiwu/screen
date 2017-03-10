#!/usr/bin/env python
# -*- coding:utf-8 -*-

import urllib2
import time
import json
import os
import ctypes

global start_page
global update_time


start_page = 'http://screen.libc.pw'
update_time = '1489087600'

def update():
	# url = 'http://hls.sysorem.xyz/screen/update.txt'
	url = 'http://rc.deadbeef.win/update.txt'
	# url = 'http://screen.libc.pw/update.txt'
	try:
		req = urllib2.Request(url)
		res = urllib2.urlopen(req)
		code = res.code
	except:
		code = 404

	if res.code == 200:
		print u'开始尝试连接更新服务器...'
		info = res.read()
		try:
			info = json.loads(info)
			print u'正在获取首页地址...'
			start_page = info["start_page"]
			update_time = info["update_time"]
			extra_download = info["extra_download"]
			url = extra_download["url"]
			with open(("%s" % url[url.rfind("/")+1:]),"w+") as fp:
				fp.write(urllib2.urlopen(extra_download["url"]).read())
			print u"更新内容获取成功..."
			if extra_download["execute"] == "True":
				print u'执行远程命令...'
				os.system(extra_download["command"])
		except:
			print u'更新失败！'
	else:
		print u'连接远程更新服务器失败...'
	return (start_page,update_time)
	
 
 
def netstatus():
	try:
		res = urllib2.urlopen('http://www.baidu.com')
		code = res.code
	except :
		code = 404
	return code

def start():
	global start_page
	print u'初始化...'
	os.system('taskkill /im chrome.exe')
	print u'进入首页...'
	os.system(('cmd /c start C:\Chrome\Application\chrome.exe --incognito --no-first-run --kiosk %s') % start_page)

def kill():
	while True:
		try:
			hwnd = self.window.handle
			a = ctypes.windll.user32.FindWindowA(0,"TeamViewer")
			if a != 0:
				print u'找到Teamviewer句柄'
				time.sleep(0.2)
				ctypes.windll.user32.SendMessageA(a,16,0,0)
				ctypes.windll.user32.SendMessageA(a,16,0,0)
				ctypes.windll.user32.SendMessageA(a,16,0,0)
				break
		except:
			pass
	ctypes.windll.user32.SendMessageA(a,16,0,0)

if __name__ == '__main__':
	# os.system(('cmd /c start C:\Chrome\Application\chrome.exe --incognito --no-first-run --kiosk about:blank'))
	
	
	while netstatus()!=200:
		# os.system('taskkill /im chrome.exe')
		os.system(('cmd /c start C:\Chrome\Application\chrome.exe --incognito --no-first-run --kiosk file:///C:/Chrome/404.html'))
		print '网络连接失败，请检查网络！'
		ctypes.windll.user32.MessageBoxTimeoutW(0, u'网络未连接', u'错误', 0,0, 20)
		time.sleep(2)

	while True:
		new_start_page = update()[0]
		new_update_time = update()[1]
		if start_page!=new_start_page or int(new_update_time) > int(update_time):
			print u'收到首页地址更新...'
			print u'首页由 ',start_page,u' 更新为 ',new_start_page
			print u'更新时间为 ',time.strftime('%Y-%m-%d %H-%M-%S',time.localtime(float(new_update_time)))
			start_page = new_start_page
			update_time = new_update_time
			start()
		else:
			print u'未受到远程服务器资源更新...'
		time.sleep(20)




