require 'spec_helper'

describe 'Morpheus answers with sublemmas' do
  # Morpheus's answer to Dardanis, one reading per entry kept: Dardani's own word, Dardanus#1's own word and its
  # Dardanis, given inside its entry, and Dardanus#2's own word
  let(:response) do
    Parser::Response.new('Dardanis', Nokogiri::XML(<<~XML), latin: true)
      <words>
      <word>
      <form xml:lang="lat">Dardanis</form>
      <entry>
      <dict>
      <hdwd xml:lang="lat">Dardani</hdwd>
      <pofs order="3">noun</pofs>
      <decl>2nd</decl>
      <gend>masculine</gend>
      </dict>
      <infl>
      <term xml:lang="lat"><stem>Darda^n</stem><suff>i_s</suff></term>
      <pofs order="3">noun</pofs>
      <decl>2nd</decl>
      <case order="5">dative</case>
      <gend>masculine</gend>
      <num>plural</num>
      <stemtype>us_i</stemtype>
      </infl>
      </entry>
      <entry>
      <dict>
      <hdwd xml:lang="lat">Dardanus#1</hdwd>
      <pofs order="2">adjective</pofs>
      <decl>1st &amp; 2nd</decl>
      </dict>
      <infl>
      <term xml:lang="lat"><stem>Darda^n</stem><suff>i_s</suff></term>
      <pofs order="2">adjective</pofs>
      <decl>1st &amp; 2nd</decl>
      <case order="5">dative</case>
      <gend>masculine</gend>
      <num>plural</num>
      <stemtype>us_a_um</stemtype>
      </infl>
      </entry>
      <entry>
      <dict>
      <hdwd xml:lang="lat">Dardanus#1</hdwd>
      <sublemma xml:lang="lat">Dardanis</sublemma>
      <pofs order="3">noun</pofs>
      <decl>3rd</decl>
      <gend>feminine</gend>
      </dict>
      <infl>
      <term xml:lang="lat"><stem>Darda^n</stem><suff>is</suff></term>
      <pofs order="3">noun</pofs>
      <decl>3rd</decl>
      <case order="7">nominative</case>
      <gend>feminine</gend>
      <num>singular</num>
      <stemtype>is_idis</stemtype>
      </infl>
      </entry>
      <entry>
      <dict>
      <hdwd xml:lang="lat">Dardanus#2</hdwd>
      <pofs order="2">adjective</pofs>
      <decl>1st &amp; 2nd</decl>
      </dict>
      <infl>
      <term xml:lang="lat"><stem>Darda^n</stem><suff>i_s</suff></term>
      <pofs order="2">adjective</pofs>
      <decl>1st &amp; 2nd</decl>
      <case order="5">dative</case>
      <gend>masculine</gend>
      <num>plural</num>
      <stemtype>us_a_um</stemtype>
      </infl>
      </entry>
      </word>
      </words>
    XML
  end

  specify 'xml' do
    dicts = Nokogiri::XML(response.bamboo_xml).xpath('//entry/dict').map { |dict| dict.elements.map(&:to_xml) }

    expect(dicts).to eq(
      [
        [
          '<hdwd xml:lang="lat">Dardani</hdwd>',
          '<pofs order="3">noun</pofs>',
          '<decl>2nd</decl>',
          '<gend>masculine</gend>',
        ],
        ['<hdwd xml:lang="lat">Dardanus1</hdwd>', '<pofs order="2">adjective</pofs>', '<decl>1st &amp; 2nd</decl>'],
        [
          '<hdwd xml:lang="lat">Dardanus1</hdwd>',
          '<sublemma xml:lang="lat">Dardanis</sublemma>',
          '<pofs order="3">noun</pofs>',
          '<decl>3rd</decl>',
          '<gend>feminine</gend>',
        ],
        ['<hdwd xml:lang="lat">Dardanus2</hdwd>', '<pofs order="2">adjective</pofs>', '<decl>1st &amp; 2nd</decl>'],
      ],
    )
  end

  specify 'json' do
    bodies = JSON.parse(response.bamboo_json.to_json)['RDF']['Annotation']['Body']

    expect(bodies.map { |body| body['rest']['entry']['dict'] }).to eq(
      [
        {
          'hdwd' => { 'lang' => 'lat', '$' => 'Dardani' },
          'pofs' => { 'order' => 3, '$' => 'noun' },
          'decl' => { '$' => '2nd' },
          'gend' => { '$' => 'masculine' },
        },
        {
          'hdwd' => { 'lang' => 'lat', '$' => 'Dardanus1' },
          'pofs' => { 'order' => 2, '$' => 'adjective' },
          'decl' => { '$' => '1st & 2nd' },
        },
        {
          'hdwd' => { 'lang' => 'lat', '$' => 'Dardanus1' },
          'sublemma' => { 'lang' => 'lat', '$' => 'Dardanis' },
          'pofs' => { 'order' => 3, '$' => 'noun' },
          'decl' => { '$' => '3rd' },
          'gend' => { '$' => 'feminine' },
        },
        {
          'hdwd' => { 'lang' => 'lat', '$' => 'Dardanus2' },
          'pofs' => { 'order' => 2, '$' => 'adjective' },
          'decl' => { '$' => '1st & 2nd' },
        },
      ],
    )
    expect(bodies.map { |body| body['about'] }.uniq.size).to eq(4)
  end
end
