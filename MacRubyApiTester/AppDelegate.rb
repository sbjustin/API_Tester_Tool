#
#  AppDelegate.rb
#  MacRubyApiTester
#
#  Created by Justin Nash on 6/1/12.
#  Copyright 2012 __MyCompanyName__. All rights reserved.
#
require 'net/http'
require 'json'

class AppDelegate
    
    attr_accessor :window
    attr_accessor :api_url
    attr_accessor :content_type
    attr_accessor :username
    attr_accessor :userpass
    attr_accessor :response
    attr_accessor :request_textfield
    attr_accessor :http_basic_checkbox
    
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
    end
    
    def windowWillClose(sender); exit; end
    
    def awakeFromNib
        api_url.stringValue = "http://localhost:3000/events"
        content_type.stringValue = "application/json"
        username.stringValue = "kirk@example.com"
        userpass.stringValue = "password123"
        event_json = {
            "event" => {
                "activity_time" => "2012-05-20 18:00:00",
                "activity_type" => "Ping Pong",
                "tweet" => "Ping Pong" + " @ " + "2012-05-20 18:00:00" + " @ 42259"
            }
        }.to_json
        
        location_json = {
            "location" => {
                "street" => "42259 St. Huberts Pl",
                "city" => "Chantilly",
                "state" => "VA",
                "country" => "USA",
                "zip" => "20152"
            }
        }.to_json
        
        request_textfield.string = event_json + "\n\n\n" + location_json
        
        end

    def api_get(sender)
        uri = URI(api_url.stringValue)
        
        req = Net::HTTP::Get.new(uri.request_uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme == 'https'
        req.basic_auth username.stringValue, userpass.stringValue if http_basic_checkbox.state == 1
        req.set_content_type(content_type.stringValue)
        res = http.start() {|h|
            h.request(req)
       } 
       
        #uri = URI(api_url.stringValue)
        
        #req = Net::HTTP::Get.new(uri.request_uri)
        #req.use
        #req.basic_auth username.stringValue, userpass.stringValue if http_basic_checkbox.state == 1
        #req.set_content_type(content_type.stringValue)
        #res = Net::HTTP.start(uri.host, uri.port) {|http|
            #http.request(req)
            #} 
        #
        
        
        response.string = res.body.gsub(",\"",",\n\t").gsub("\"","").gsub("[","\n[\n").gsub("]","]").gsub("{","\n\t{\n\t").gsub("}","\n}")
    end

    def api_post(sender)
        uri = URI(api_url.stringValue)        
        req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' => content_type.stringValue })
        req.basic_auth username.stringValue, userpass.stringValue if http_basic_checkbox.state == 1
        req.body = JSON.parse(request_textfield.string).to_json
        res = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
        response.string = res.body
    end
    
    def api_delete(sender)
        uri = URI(api_url.stringValue)
        
        req = Net::HTTP::Delete.new(uri.request_uri,initheader = {'Depth' => 'Infinity'})
        req.basic_auth username.stringValue, userpass.stringValue if http_basic_checkbox.state == 1
        res = Net::HTTP.start(uri.host, uri.port) {|http|
            http.request(req)
        }
        puts res.header.to_s + res.body.to_s
        response.string = res.header.to_s + res.body

    end










end

