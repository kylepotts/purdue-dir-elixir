{application,purduedir,
             [{registered,[]},
              {description,"purduedir"},
              {vsn,"0.0.1"},
              {modules,['Elixir.Purduedir','Elixir.Purduedir.GetHtml',
                        'Elixir.Purduedir.Plug.Router',
                        'Elixir.Purduedir.PrintPerson',
                        'Elixir.Purduedir.ScrapeHtml']},
              {mod,{'Elixir.Purduedir',[]}},
              {applications,[kernel,stdlib,elixir,logger,httpoison,cowboy,
                             plug,redix,table_rex,httpoison,json,plug,redix,
                             table_rex,exquery]}]}.