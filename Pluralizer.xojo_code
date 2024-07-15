#tag Class
Protected Class Pluralizer
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  Var Rules() As String
		  
		  Rules = kPluralRules.Split(EndOfLine.CR)
		  For Each s As String In Rules
		    Var r As New RegEx
		    r.SearchPattern = s.NthField(",", 1)
		    r.ReplacementPattern = s.NthField(",", 2)
		    PluralRules.Add(r)
		  Next s
		  
		  Rules = kSingularRules.Split(EndOfLine.CR)
		  For Each s As String In Rules
		    Var r As New RegEx
		    r.SearchPattern = s.NthField(",", 1)
		    r.ReplacementPattern = s.NthField(",", 2)
		    SingularRules.Add(r)
		  Next s
		  
		  Uncountables = kUncountable.Split(EndOfLine.CR)
		  
		  IrregularPlurals = New Dictionary
		  Rules = kIrregular.Split(EndOfLine.CRLF)
		  For Each s As String In Rules
		    IrregularPlurals.Value(s.NthField(",", 2)) = s.NthField(",", 1)
		  Next s
		  
		  IrregularSingles = New Dictionary
		  Rules = kIrregular.Split(EndOfLine.CRLF)
		  For Each s As String In Rules
		    IrregularSingles.Value(s.NthField(",", 1)) = s.NthField(",", 2)
		  Next s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetInstance() As Pluralizer
		  If mInstance Is Nil Then
		    mInstance = New Pluralizer
		  End If
		  
		  Return mInstance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsPlural(Word As String) As Boolean
		  If Uncountables.IndexOf(word) > -1 Then
		    Return False
		  End If
		  
		  If IrregularPlurals.HasKey(word) Then
		    Return True
		  End If
		  
		  For Each r As RegEx In PluralRules
		    If r.Search(Word) <> Nil Then
		      Return True
		    End If
		  Next
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsSingular(Word As String) As Boolean
		  If Uncountables.IndexOf(word) > -1 Then
		    Return False
		  End If
		  
		  If IrregularSingles.HasKey(word) Then
		    Return True
		  End If
		  
		  For Each r As RegEx In SingularRules
		    Var rm As RegExMatch = r.Search(Word)
		    If rm <> Nil Then
		      Return True
		    End If
		  Next
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pluralize(Word As String) As String
		  Var Result As String = Transform(Word, Uncountables, IrregularSingles, PluralRules)
		  
		  Return RestoreCase(Word, Result)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RestoreCase(originalWord As String, newWord As String) As String
		  If originalWord.Compare(originalWord.Uppercase, ComparisonOptions.CaseSensitive) = 0 Then
		    Return newWord.Uppercase
		  End If
		  
		  If originalWord.Compare(originalWord.Titlecase, ComparisonOptions.CaseSensitive) = 0 Then
		    Return newWord.Titlecase
		  End If
		  
		  Return newWord
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Singularize(Word As String) As String
		  Var Result As String = Transform(Word, Uncountables, IrregularPlurals, SingularRules)
		  
		  Return RestoreCase(Word, Result)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Transform(Word As String, Uncountables() As String, Irregular As Dictionary, Rules() As RegEx) As String
		  If Uncountables.IndexOf(word) > -1 Then
		    Return Word
		  End If
		  
		  If Irregular.HasKey(word) Then
		    Return Irregular.Value(word)
		  End If
		  
		  For Each r As RegEx In Rules
		    If r.Search(Word) <> Nil Then
		      Return r.Replace(Word, 0)
		    End If
		  Next
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private IrregularPlurals As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IrregularSingles As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mInstance As Pluralizer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PluralRules() As RegEx
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SingularRules() As RegEx
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Uncountables() As String
	#tag EndProperty


	#tag Constant, Name = kIrregular, Type = String, Dynamic = False, Default = \"I\x2Cwe\r\nme\x2Cus\r\nhe\x2Cthey\r\nshe\x2Cthey\r\nthem\x2Cthem\r\nmyself\x2Courselves\r\nyourself\x2Cyourselves\r\nitself\x2Cthemselves\r\nherself\x2Cthemselves\r\nhimself\x2Cthemselves\r\nthemself\x2Cthemselves\r\nis\x2Care\r\nwas\x2Cwere\r\nhas\x2Chave\r\nthis\x2Cthese\r\nthat\x2Cthose\r\necho\x2Cechoes\r\ndingo\x2Cdingoes\r\nvolcano\x2Cvolcanoes\r\ntornado\x2Ctornadoes\r\ntorpedo\x2Ctorpedoes\r\ngenus\x2Cgenera\r\nviscus\x2Cviscera\r\nstigma\x2Cstigmata\r\nstoma\x2Cstomata\r\ndogma\x2Cdogmata\r\nlemma\x2Clemmata\r\nschema\x2Cschemata\r\nanathema\x2Canathemata\r\nox\x2Coxen\r\naxe\x2Caxes\r\ndie\x2Cdice\r\nyes\x2Cyeses\r\nfoot\x2Cfeet\r\neave\x2Ceaves\r\ngoose\x2Cgeese\r\ntooth\x2Cteeth\r\nquiz\x2Cquizzes\r\nhuman\x2Chumans\r\nproof\x2Cproofs\r\ncarve\x2Ccarves\r\nvalve\x2Cvalves\r\nlooey\x2Clooies\r\nthief\x2Cthieves\r\ngroove\x2Cgrooves\r\npickaxe\x2Cpickaxes\r\nwhiskey\x2Cwhiskies\r\nperson\x2Cpeople\r\n", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kPluralRules, Type = String, Dynamic = False, Default = \"s\?$\x2Cs\r\n[^\\u0000-\\u007F]$\x2C$0\r\n([^aeiou]ese)$\x2C$1\r\n(ax|test)is$\x2C$1es\r\n(alias|[^aou]us|tlas|gas|ris)$\x2C$1es\r\n(e[mn]u)s\?$\x2C$1s\r\n([^l]ias|[aeiou]las|[emjzr]as|[iu]am)$\x2C$1\r\n(alumn|syllab|octop|vir|radi|nucle|fung|cact|stimul|termin|bacill|foc|uter|loc|strat)(\?:us|i)$\x2C$1i\r\n(alumn|alg|vertebr)(\?:a|ae)$\x2C$1ae\r\n(seraph|cherub)(\?:im)\?$\x2C$1im\r\n(her|at|gr)o$\x2C$1oes\r\n(agend|addend|millenni|dat|extrem|bacteri|desiderat|strat|candelabr|errat|ov|symposi|curricul|automat|quor)(\?:a|um)$\x2C$1a\r\n(apheli|hyperbat|periheli|asyndet|noumen|phenomen|criteri|organ|prolegomen|hedr|automat)(\?:a|on)$\x2C$1a\r\nsis$\x2Cses\r\n(\?:(kni|wi|li)fe|(ar|l|ea|eo|oa|hoo)f)$\x2C$1$2ves\r\n([^aeiouy]|qu)y$\x2C$1ies\r\n([^ch][ieo][ln])ey$\x2C$1ies\r\n(x|ch|ss|sh|zz)$\x2C$1es\r\n(matr|cod|mur|sil|vert|ind|append)(\?:ix|ex)$\x2C$1ices\r\n(m|l)(\?:ice|ouse)$\x2C$1ice\r\n(pe)(\?:rson|ople)$\x2C$1ople\r\n(child)(\?:ren)\?$\x2C$1ren\r\neaux$\x2C$0\r\nm[ae]n$\x2Cmen\r\n^thou$\x2Cyou \r\npox$\x2C $0\r\nois$\x2C $0\r\ndeer$\x2C$0\r\nfish$\x2C$0\r\nsheep$\x2C $0\r\nmeasles$/\x2C$0\r\n[^aeiou]ese$\x2C$0}", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kSingularRules, Type = String, Dynamic = False, Default = \"s$\x2C\r\n(ss)$\x2C$1\r\n((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(\?:sis|ses)$\x2C$1sis\r\n(^analy)(\?:sis|ses)$\x2C$1sis\r\n(wi|kni|(\?:after|half|high|low|mid|non|night|[^\\\\w]|^)li)ves$\x2C$1fe\r\n(ar|(\?:wo|[ae])l|[eo][ao])ves$\x2C$1f\r\nies$\x2Cy\r\n\\\\b([pl]|zomb|(\?:neck|cross)\?t|coll|faer|food|gen|goon|group|lass|talk|goal|cut)ies$\x2C$1ie\r\n\\\\b(mon|smil)ies$\x2C$1ey\r\n(m|l)ice$\x2C$1ouse\r\n(seraph|cherub)im$\x2C$1\r\n(x|ch|ss|sh|zz|tto|go|cho|alias|[^aou]us|tlas|gas|(\?:her|at|gr)o|ris)(\?:es)\?$\x2C$1\r\n(e[mn]u)s\?$\x2C$1\r\n(movie|twelve)s$\x2C$1\r\n(cris|test|diagnos)(\?:is|es)$\x2C$1is\r\n(alumn|syllab|octop|vir|radi|nucle|fung|cact|stimul|termin|bacill|foc|uter|loc|strat)(\?:us|i)$\x2C$1us\r\n(agend|addend|millenni|dat|extrem|bacteri|desiderat|strat|candelabr|errat|ov|symposi|curricul|quor)a$\x2C$1um\r\n(apheli|hyperbat|periheli|asyndet|noumen|phenomen|criteri|organ|prolegomen|hedr|automat)a$\x2C$1on\r\n(alumn|alg|vertebr)ae$\x2C$1a\r\n(cod|mur|sil|vert|ind)ices$\x2C$1ex\r\n(matr|append)ices$\x2C$1ix\r\n(pe)(rson|ople)$\x2C$1rson\r\n(child)ren$\x2C$1\r\n(eau)x\?$\x2C$1\r\nmen$\x2Cman \r\npox$\x2C $0\r\nois$\x2C $0\r\ndeer$\x2C$0\r\nfish$\x2C$0\r\nsheep$\x2C $0\r\nmeasles$/\x2C$0\r\n[^aeiou]ese$\x2C$0}", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kUncountable, Type = String, Dynamic = False, Default = \"advice\r\nadulthood\r\nagenda\r\naid\r\nalcohol\r\nammo\r\nathletics\r\nbison\r\nblood\r\nbream\r\nbuffalo\r\nbutter\r\ncarp\r\ncash\r\nchassis\r\nchess\r\nclothing\r\ncommerce\r\ncod\r\ncooperation\r\ncorps\r\ndigestion\r\ndebris\r\ndiabetes\r\nenergy\r\nequipment\r\nelk\r\nexcretion\r\nexpertise\r\nflounder\r\nfun\r\ngallows\r\ngarbage\r\ngraffiti\r\nheadquarters\r\nhealth\r\nherpes\r\nhighjinks\r\nhomework\r\nhousework\r\ninformation\r\njeans\r\njustice\r\nkudos\r\nlabour\r\nliterature\r\nmachinery\r\nmackerel\r\nmail\r\nmedia\r\nmews\r\nmoose\r\nmusic\r\nnews\r\npike\r\nplankton\r\npliers\r\npollution\r\npremises\r\nrain\r\nresearch\r\nrice\r\nsalmon\r\nscissors\r\nseries\r\nsewage\r\nshambles\r\nsheep\r\nshrimp\r\nspecies\r\nstaff\r\nswine\r\ntrout\r\ntraffic\r\ntransporation\r\ntuna\r\nwealth\r\nwelfare\r\nwhiting\r\nwildebeest\r\nwildlife\r\nyou", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
