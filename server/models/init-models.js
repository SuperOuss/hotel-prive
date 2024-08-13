const DataTypes = _sequelize.DataTypes;
import _sequelize from "sequelize";
import _user from "./user.js";
import _hotel from "./hotel.js";


export default function initModels(sequelize) {

  const user = _user.init(sequelize, DataTypes);
  const hotel = _hotel.init(sequelize, DataTypes);   

  // Setting up associations
/*   user.hasMany(comments, { foreignKey: 'userId', as: 'comments' });
  location.hasMany(comments, { foreignKey: 'locationId', as: 'comments' });


  comments.belongsTo(user, { foreignKey: 'userId', as: 'user' });
  comments.belongsTo(location, { foreignKey: 'locationId', as: 'location' });

  statusChangeLog.belongsTo(user, { foreignKey: 'userId', as: 'user' });
  statusChangeLog.belongsTo(location, { foreignKey: 'locationId', as: 'location' });

  organisation.hasMany(user, { foreignKey: 'orgId', as: 'users' });
  user.belongsTo(organisation,{ foreignKey:'orgId', as: 'organisation' })

  // Existing associations
  user.hasMany(location);
  location.belongsTo(user);
  
  organisation.hasMany(location, { foreignKey: 'orgId', as: 'location' });
  location.belongsTo(organisation,{ foreignKey:'orgId', as: 'organisation' })

  idcs.belongsTo(location, { foreignKey: 'locationId', as: 'location' });
  gasTracking.belongsTo(user, { foreignKey: 'userId', as: 'user' } )
  user.hasMany(gasTracking, { foreignKey: 'userId', as: 'gasTracking' });
  transactions.belongsTo(location, { foreignKey: 'locationId', as: 'location' });
  location.hasMany(transactions, { foreignKey: 'locationId', as: 'transactions' }); */


  return {
    user,
    hotel
  };
}