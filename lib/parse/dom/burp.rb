require 'rexml/document'

# http://www.germane-software.com/software/rexml/docs/tutorial.html

module Parse
  module DOM
    class Burp
      def parse_file(xml_file)
        struct = nil
        begin
	        struct = __extract_xml(xml_file)
        rescue Exception => e
          raise Exception.new 'XML with invalid format'
        end
        return struct
      end
     
     
      private
      def __extract_xml(xml_file)
        doc = REXML::Document.new File.new(xml_file)
        output = {}
        output[:issues] = []
        duration = 'N/A'
        toolname= 'Burp Suite'
        start='N/A'

        path="//issues/issue"
        output[:issues] = doc.elements.collect(path) do |issue|  
          {
            :name => issue.elements['name'].text.to_s,
            :url =>  issue.elements['host'].text.to_s,
            :description => issue.elements['issueBackground'].text.gsub!(/<\/?[^>]*>/,""),
            :remedy_guidance => issue.elements['remediationBackground'].nil? ? '' : issue.elements['remediationBackground'].text.to_s,  
            :affected_component => issue.elements['host'].text.to_s + issue.elements['path'].text.to_s, 
            :severity => issue.elements['severity'].text.to_s,
            :_hash => issue.elements['serialNumber'].text.to_s
              
         }
        end
        output[:duration]=duration
        output[:start_datetime]=start
        output[:toolname]=toolname

        output[:issues].uniq!
        
        return output
      end
        
    end
  end
end
