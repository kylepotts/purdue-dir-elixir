{application,redix,
             [{registered,[]},
              {description,"Superfast, pipelined, resilient Redis driver for Elixir.\n"},
              {vsn,"0.3.6"},
              {modules,['Elixir.Redix','Elixir.Redix.Connection',
                        'Elixir.Redix.Connection.Auth',
                        'Elixir.Redix.Connection.Receiver',
                        'Elixir.Redix.ConnectionError','Elixir.Redix.Error',
                        'Elixir.Redix.Protocol',
                        'Elixir.Redix.Protocol.ParseError',
                        'Elixir.Redix.PubSub',
                        'Elixir.Redix.PubSub.Connection','Elixir.Redix.URI',
                        'Elixir.Redix.URI.URIError','Elixir.Redix.Utils']},
              {applications,[kernel,stdlib,elixir,logger,connection]}]}.