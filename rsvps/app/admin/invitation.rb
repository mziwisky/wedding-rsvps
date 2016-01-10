ActiveAdmin.register Invitation do

  permit_params :seen, :responded, :access_code # TODO: remove this -- explicitly creating Invitation models (w/o guests) will not be allowed

end
